%**********************************************************************
%  Project: DTMF
%  File: DTMF_gen_LUT.m
%  Description: generate DTMF using LUT method
%  Author: Ruiqi Tang
%  Timestamp:
%----------------------------------------------------------------------
% Code Revision History:
% Ver:     | Author    | Mod. Date     | Changes Made:
% v1.0.0   | R.T.      | 2024/04/16    | Initial version
%**********************************************************************
clear; clc; close all;

% read the LUT
fileID = fopen('../sinLUT.hex', 'r');
sinLUT = fscanf(fileID, '%x');
fclose(fileID);

% recover the 4 quadrants of sinLUT
N = length(sinLUT); % resolution of the LUT
sinLUTr = zeros(1, N * 4);
sinLUTr(1:N) = sinLUT;
sinLUTr(N + 1:2 * N) = sinLUT(end:-1:1);
sinLUTr(2 * N + 1:3 * N) = -sinLUT;
sinLUTr(3 * N + 1:4 * N) = -sinLUT(end:-1:1);

% frequency of the DTMF
row = [697, 770, 852, 941];
col = [1209, 1336, 1477, 1633];

% generate DTMF
fs = 8000; % sampling frequency
duration = 0.1; % duration of the DTMF
t = 0:1:duration*fs;
dtmf = zeros(1, length(t));

% generate & plot DTMF for each row and column
figure;

for i = 1:4

    for j = 1:4
        % generate DTMF
        % dtmf = sinLUTr(mod(round(row(i) / fs * 4 * N * t), 4 * N)) + sinLUTr(mod(round(col(j) / fs * 4 * N * t), 4 * N));
        for k = 1:length(t)
            dtmf(k) = sinLUTr(mod(round(row(i) / fs * 4 * N * t(k)), 4 * N) + 1) + sinLUTr(mod(round(col(j) / fs * 4 * N * t(k)), 4 * N) + 1);
        end

        % plot DTMF and the FFT
        subplot(4, 4, (i - 1) * 4 + j);
        plot(t, dtmf);
        title(['DTMF: ', num2str(row(i)), 'Hz + ', num2str(col(j)), 'Hz']);
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;

        subplot(4, 4, (i - 1) * 4 + j);
        f = linspace(0, fs, length(t));
        dtmf_fft = fft(dtmf);
        dtmf_fft = dtmf_fft(1:floor(length(t) / 2) + 1);
        f = f(1:floor(length(t) / 2) + 1);
        plot(f, abs(dtmf_fft));
        title(['FFT of DTMF: ', num2str(row(i)), 'Hz + ', num2str(col(j)), 'Hz']);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        grid on;

    end

end
