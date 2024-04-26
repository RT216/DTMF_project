fs = 8000;       % sampling frequeny
t = 0:1/fs:0.5;  % signal duration
f1 = 697;        % Frequency component 1
f2 = 1633;       % Frequency component 2
frq = [697, 770, 852, 941, 1209, 1336, 1477, 1633];
% sig gen
dtmf_signal = sin(2*pi*f1*t) + sin(2*pi*f2*t);

% LPC
p = 10;                       % LPC order
[a, g] = lpc(dtmf_signal, p); % LPC parameters
[h, w] = freqz(sqrt(g), a, 512, fs); % Freq response
h_sorted = sort(abs(h), "descend");

SNR = 20*log10( (h_sorted(1) + h_sorted(2)) ...
/(sum(h_sorted) - (h_sorted(1) + h_sorted(2))));

% visualisation
figure;
subplot(2, 1, 1);
plot(t, dtmf_signal);
title('Original DTMF Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(w, 20*log10(abs(h)));
title(["Frequency Response of LPC Model, SNR:", SNR]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

