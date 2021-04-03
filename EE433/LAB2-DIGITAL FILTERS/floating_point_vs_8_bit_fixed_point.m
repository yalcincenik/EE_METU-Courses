% Aim of the this script is to show that 8-bit fixed point representation is almost equivalent to floating point representation
% To do this, we can perform signal processing implementations on FPGA, where it does not accept floating point. 
% We will show that IIR filtering operations yield the same result with both representations.
  
  % First floating point representation
  x = rand(1,256);
  y = zeros(1,256);
y(1) = x(1);

for i=2:length(x)
  y(i) = 0.5*y(i-1)+x(i);
end
  
  % Fixed point representation
  bit_depth = 8;
  x_fixed = (2^bit_depth)*x;
  y_fixed = (2^bit_depth)*zeros(1,256);
  y_fixed(1) = x_fixed(1);

for j = 2:length(x_fixed)
  y_fixed = (2^(bit_depth))*0.5*y_fixed(j-1)+x_fixed(j);
end
  y_fixed = y_fixed /(2^bit_depth);

% Comparisions the result in the same figure
  n = 1:256;
  plot(n,y);
  hold on;
  plot(n,y_fixed);
  hold off;

% Error Analysis
  error = y-y_fixed ;
  plot(n,error);
