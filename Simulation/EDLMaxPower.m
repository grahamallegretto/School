function EDLMaxPower
%EDLMAXPOWER Summary of this function goes here
%   Detailed explanation goes here

close all

%% Parameters
maxFreq = 30;
maxR = 20e6;
dr = 0.1e6; 

%% Perform Simulations
resistance = dr:dr:maxR;
freqs = 1:maxFreq;
pkPower = zeros(size(resistance,2),maxFreq);
avgPower = zeros(size(resistance,2),maxFreq);

for j = freqs 
    for i = 1:size(resistance,2)
        [~, ~, v] = EDLSimulation('sine', resistance(i), 0.7, j, false);
        [pkPower(i,j) avgPower(i,j)] = powerCalc(v, i*10^6); 
    end
    [maxPower(j),maxPowerIdx(j)] = max(avgPower(:,j));
end

%% Plot
temp = subplot(1,2,1);
hold(temp,'on');
for j = freqs 
    plot(resistance,avgPower(:,j),resistance(maxPowerIdx(j)),maxPower(j),'r*');
end
title('Average Power');
xlabel('Resistance (Ohm)');
ylabel('Average Power (W)');

subplot(1,2,2);
plot(freqs,resistance(maxPowerIdx(:)),'.',freqs,2.198e7./freqs); 
title('Resistance Vs. Frequency');
xlabel('Frequency (f)');
ylabel('Resistance (R)');

end

