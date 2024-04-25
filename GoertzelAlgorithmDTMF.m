% Sampling frequency
Fs = 8000;

% Pickup signal vector size
N  = 205;

% DTMF frequency vector
frq = [697, 770, 852, 941, 1209, 1336, 1477, 1633];

% Spectral sample DTMF index vector (indexation begins with 0)
%ind = [18,  20,  22,  24,  31,   34,   38,   42];
ind = round(frq./Fs.*N);
% Sampling moments of the pickup DTMF signal
t = (0:N-1) / Fs;

for(k = 1:4)  
  for(m = 1:4)
    % DTMF signal
    s = sin(2*pi*frq(k)*t) + sin(2*pi*frq(m+4)*t);
    [k, m]
    [frq(k), frq(m+4)]
    % Spectral sample vector
    S = goertzel(s, ind);  
    SNR = 20*log10((abs(S(k))+abs(S(m+4)))/(sum(abs(S))-abs(S(k))-abs(S(m+4))));
    
    % Domain waveform
    figure(1); 
    grid on;
    subplot(4,4,(k-1)*4+m); 
    plot(t,s); axis([0, 0.025, -2, 2]);

    % Spectral samples magnitudes
    figure(2); 
    grid on;
    subplot(4,4,(k-1)*4+m);
    
    display(S);
    stem(frq,abs(S), '.'); axis([500, 1800, 0, 130]);
    xlabel(["SNR: ", SNR], "FontSize",7);
    sgtitle("DTMF Detection based on Goerztel Alogrithm");
  end 
end					
