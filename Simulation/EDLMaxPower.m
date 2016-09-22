function [pkPower avgPower] = EDLMaxPower
%EDLMAXPOWER Summary of this function goes here
%   Detailed explanation goes here

pkPower = zeros(10,10);
avgPower = zeros(10,10);
for j = 1:10
    for i = 1:40
        [v, t] = EDLSimulation('sine', i*0.5*10^6, 0.7, j, false);
        [pkPower(i,j) avgPower(i,j)] = powerCalc(v, i*10^6); 
    end
end

hold on
for j = 1:10
    plot(avgPower(:,j));
end

end

