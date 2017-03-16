function rSquare = EDLVoltageFind( filename, Rl )
%EDLVOLTAGEFIND Summary of this function goes here
%   Detailed explanation goes here

EDLVoltage = 0.1:0.1:1.0;
rSquare = zeros(size(EDLVoltage));

for i = 1:size(EDLVoltage,2)
    rSquare(i) = EDLSimulation( filename, Rl, EDLVoltage(i) );
end
close all;

plot(EDLVoltage,rSquare)

