function [ pkPower, avgPower ] = powerCalc( voltage, R )
%POWERCALC Summary of this function goes here
%   Detailed explanation goes here

power = (voltage.^2) / R;
avgPower = mean(power);
pkPower = max(power);

end

