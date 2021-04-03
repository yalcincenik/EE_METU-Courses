% EE 433 LAB1 Preliminary Work
% Student Name : Yalçın Cenik
% Student ID: 2007565

% Define the sequence
x = [2, 0, 0, 7, 5,6];
y = fft(x,6);
Y_mag = abs(y);
Y_phase = phase(y);
N = 0:5;
subplot(1,2,1);
stem(N,Y_mag,'filled');
title('Magnitude');
xlabel('k');
ylabel('|X[k]|');
subplot(1,2,2);
stem(N,Y_phase,'filled');
xlabel('k');
ylabel('Phase');
title('Phase');
x = [2, 0, 0, 7, 5,6]; 
M = 0:8;
z = fft(x,9);
Z_mag = abs(z);
Z_phase = phase(z);
subplot(1,2,1);
stem(M,Z_mag,'filled');
title('Magnitude');
xlabel('k');
ylabel('|X[k]|');
subplot(1,2,2);
stem(M,Z_phase,'filled');
xlabel('k');
ylabel('Phase');
title('Phase');
z_inv = ifft(z,9);
plot(z_inv);
z_inv_2 = ifft(z,6);
v = fft(x,4);
v_inv = ifft(v,4);
