% EE433 LAB-2 Prelimnary Work
% Triangular wave generation

T = 10*(1/200); % Frequency = 200 Hz

fs = 4000;  % Sampling Frequency = 4000 Hz
t = 0:1/fs:T-1/fs; 

x = sawtooth(2*pi*200*t,1/2); % Triangular wave
plot(t,x);

% Fourier Domain Implementation of the FIR filter
h_FIR = [1 1 ]; % Simple FIR filter with linear phase
X = fft(x,8);   % 8-point FFT of the input signal
plot(20*log10(abs(X)));
H_FIR = fft(h_FIR,8); % Taken as 8-point
plot(20*log10(abs(H_FIR))); 
Y_1 = X.*H_FIR; % Fourier Domain Multiplication representation of the output
y_1 = ifft(Y_1,8); % Time Domain Represenation of the output
plot(y_1);
plot(20*log10(abs(Y_1)));

% Fourier Domain Implementation of the IIR filter 
n = 1:1;
h = ((0.5).^n).*heaviside(n);
H = fft(h,8);
plot(20*log10(abs(H)));
Y_2 = X.*H;
y_2 = ifft(Y_2,8);
plot(y_2);
plot(20*log10(abs(Y_2)))
