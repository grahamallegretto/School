function [pkPower avgPower] = EDLMaxPower
%EDLMAXPOWER Summary of this function goes here
%   Detailed explanation goes here

pkPower = zeros(10,10);
avgPower = zeros(10,10);
frequencies = 20;

for j = 1:frequencies 
    for i = 1:100
        [~, ~, v] = EDLSimulation('sine', i*0.2*10^6, 0.7, j, false);
        [pkPower(i,j) avgPower(i,j)] = powerCalc(v, i*10^6); 
    end
end

hold on
for j = 1:frequencies 
    plot(0.2:0.2:20,avgPower(:,j));
    title('Average Power');
end

end

