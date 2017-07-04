function [ pkPower, avgPower, vpp ] = powerCalc( voltage, R )
%POWERCALC Summary of this function goes here
%   Detailed explanation goes here

voltage = voltage( floor(size(voltage)*0.15):end );
vpp = max(voltage) - min(voltage);

power = (voltage.^2) / R;

avgPower = 0.5*(max(voltage)-mean(voltage))^2/R;

pkPower = max(power);

end

