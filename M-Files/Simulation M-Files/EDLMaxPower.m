function EDLMaxPower
%EDLMAXPOWER Summary of this function goes here
%   Detailed explanation goes here

close all

%% Parameters
maxFreq = 30;
maxR = 10e6;
dr = 0.05e6; 

Ct = 1.1139e-8;
dC = 5.6961e-9;
Vdl = 0.7;
Rf = 70000;

%% Perform Simulations
resistance = dr:dr:maxR;%resistorSearch(75000,2)';
freqs = 1:maxFreq;
pkPower = zeros(size(resistance,2),maxFreq);
avgPower = zeros(size(resistance,2),maxFreq);
Rl = zeros(size(freqs,2),1);
avgPowerLinear = zeros(size(freqs,2),1);

for j = freqs 
    for i = 1:size(resistance,2)
        [~, ~, v] = EDLSimulation('sine', 'Rl', resistance(i), 'Vbias', 0.7, ...
        'f', j, 'toPlot', false, 'numSamples', 10000, 'SAOffset', 20, ...
        'SAAmp', 10 );
        [pkPower(i,j), avgPower(i,j)] = powerCalc(v, resistance(i)); 
    end
    [maxPower(j),maxPowerIdx(j)] = max(avgPower(:,j));
    j
    w = 2*pi*j;
    Rl(j) = sqrt(1/((w^2)*Ct^2)+70000^2);
    avgPowerLinear(j) = 0.5*((w^2 * Rl(j) * dC^2 * Vdl^2) ...
                    /   (1 + (w * Ct * (Rl(j) + Rf))^2 ) );
end

%% Plot
hold on;
for j = freqs 
    
    plot(resistance,avgPower(:,j),...
        resistance(maxPowerIdx(j)),maxPower(j),'r*',...
        Rl(j),interp1(resistance,avgPower(:,j),Rl(j)),'b*');
end
title('Average Power');
xlabel('Resistance (Ohm)');
ylabel('Average Power (W)');

% subplot(1,2,2);
% plot(freqs,resistance(maxPowerIdx(:)),'.',freqs,2.198e7./freqs); 
% title('Resistance Vs. Frequency');
% xlabel('Frequency (f)');
% ylabel('Resistance (R)');

end

