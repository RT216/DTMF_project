%**********************************************************************
%  Project: DTMF
%  File: generate_LUT.m
%  Description: generate LUT for sin(), and store it in hex format
%               The LUT is generated for the first quadrant of sin() 
%               and then mirrored to the other quadrants.
%  Author: Ruiqi Tang
%  Timestamp:
%----------------------------------------------------------------------
% Code Revision History:
% Ver:     | Author    | Mod. Date     | Changes Made:
% v1.0.0   | R.T.      | 2024/04/15    | Initial version
% v1.0.0   | R.T.      | 2024/04/16    | modified comments
%**********************************************************************
clear; clc; close all;

N = 100; % resolution of the LUT
x = linspace(0, pi/2, N); % generate N equally spaced points between 0 and pi/2

% calculate the sin value for each x and store them in an array
sinLUT = sin(x);

% map the sin value to 12-bit unsigned integer
sinLUT = round(sinLUT * (2^12-1));

% write the LUT to a file in hex format
fileID = fopen('../sinLUT.hex', 'w');
for i = 1:N
    fprintf(fileID, '%04X\n', sinLUT(i));
end
fclose(fileID);


% demo of read and plot the LUT
fileID = fopen('../sinLUT.hex', 'r');
sinLUT = fscanf(fileID, '%x');
fclose(fileID);

sinLUTr = zeros(1, N*4);
sinLUTr(1:N) = sinLUT;
sinLUTr(N+1:2*N) = sinLUT(end:-1:1);
sinLUTr(2*N+1:3*N) = -sinLUT;
sinLUTr(3*N+1:4*N) = -sinLUT(end:-1:1);

figure;
plot(sinLUTr);
title('LUT for sin()');
xlabel('Index');
ylabel('Value');
grid on;
