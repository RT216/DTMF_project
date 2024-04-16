%**********************************************************************
%  Project: DTMF
%  File: DTMF_gen_DO.m
%  Description: generate DTMF using Digtal Oscillator Method
%  Author: Ruiqi Tang
%  Timestamp:
%----------------------------------------------------------------------
% Code Revision History:
% Ver:     | Author    | Mod. Date     | Changes Made:
% v1.0.0   | R.T.      | 2024/04/16    | Initial version
% v1.1.0   | R.T.      | 2024/04/16    | Fix the equation for DTMF
%**********************************************************************
clear; clc; close all;


% frequency of the DTMF
row = [697, 770, 852, 941];
col = [1209, 1336, 1477, 1633];

% generate DTMF
fs = 8000; % sampling frequency
n = 0:200;
dtmf = zeros(1, length(n));

% generate & plot DTMF for each row and column
for i = 1:4

    for j = 1:4
        % generate DTMF
        A1 = cos(2*pi*row(i)/fs);
        A2 = cos(2*pi*col(j)/fs);

        % Generate the input impulse signal
        h = zeros(length(n)+2); 
        h(3) = 1;

        % Generate the sine signal
        x1 = zeros(1,length(n)+2);    
        x2 = zeros(1,length(n)+2);

        for k = 3:length(n)+2
            x1(k) = 2*A1*x1(k-1) - x1(k-2) + h(k) - A1*h(k-1);
            x2(k) = 2*A2*x2(k-1) - x2(k-2) + h(k) - A2*h(k-1);
        end
        
        % Delete initial condition components
        x1(1:2) = [];
        x2(1:2) = [];

        dtmf = x1 + x2;

        % plot DTMF and the FFT
        figure(1);
        subplot(4, 4, (i - 1) * 4 + j);
        plot(n, dtmf);
        title(['DTMF: ', num2str(row(i)), 'Hz + ', num2str(col(j)), 'Hz']);
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;

        figure(2);
        subplot(4, 4, (i - 1) * 4 + j);
        dtmf_fft = fft(dtmf);
        dtmf_fft_half = dtmf_fft(1:floor(length(n) / 2) + 1);
        f = linspace(0, fs/2, floor(length(n) / 2) + 1);
        plot(f, abs(dtmf_fft_half));
        title(['FFT of DTMF: ', num2str(row(i)), 'Hz + ', num2str(col(j)), 'Hz']);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        grid on;

    end

end
