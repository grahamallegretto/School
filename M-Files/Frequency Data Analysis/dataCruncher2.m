function [output] = dataCruncher2( file, SAOffset, SAAmp, vDeadband,...
    frequencies, fDeadband  )
%DATACRUNCHER Summary of this function goes here
%   Detailed explanation goes here

close all

% Argument for separating data points based on their frequency
if nargin < 5
    fDeadband = 0.1;
end

% Read in data
data = headerIgnoreCSVRead( file );

% Make conversion from throw data to surface area assuming a linear
% response
data(:,4) = data(:,4) -  mean(data(:,4));

plot( data(:,2), data(:,4) );

%%%%% IF USING DIFFERENT AMPLITUDE CHANGE 0.25 %%%%%%%%
AGain = SAAmp / 0.25;
data(:,4) = (-1.*AGain.*data(:,4)) + (SAOffset - mean(data(:,4)));

% Normalize data
avg = mean(data(:,6));
data(:,6) = data(:,6) - avg;
[pks, troughs] = findPeaks( data(:,6), vDeadband );
   
% Calculate peak2peak and frequency
try
    % Sometimes the two arrays aren't the same size so we need to truncate
    % the longer array
    peak2peak = pks(:,2) - troughs(:,2);
catch                                     
    if size(pks,1) > size(troughs,1)
        pks = pks(1:size(troughs,1),:);
    else
        troughs = troughs(1:size(pks,1),:);
    end
    peak2peak = pks(:,2) - troughs(:,2);
end
peak2peak = peak2peak(1:end-1);
period = diff( data(pks(:,1),2) );
freq = 1./period;
dataPoints = [freq peak2peak];

% Separate the data based on frequencies
output = zeros(size(frequencies,2),3);
for i = 1:size(frequencies,2)
    
    DB = frequencies(i)*fDeadband;
    tempData = dataPoints( abs(freq-frequencies(i)) < DB, : );
    dataRange = pks( abs(freq-frequencies(i)) < DB, 1 );
    
    % Ignore the first portion of the data points and the last
    startIgnoreSpan = floor( size(tempData,1)*0.3 );
    endIgnoreSpan = floor( size(tempData,1)*0.1 );
    
    try
        tempData = tempData(startIgnoreSpan:end-endIgnoreSpan,:);
    catch
        i
    end
    dataRange = dataRange(startIgnoreSpan:end-endIgnoreSpan,:); 
    dataRange = dataRange(1):dataRange(end);
    
    % Determine the phase shift
    % Since we assume that displacement is linear in respect to  Must multiply the Surface area data by -1 because 
    % of the 
    refWave = data(dataRange,4);
    depWave = data(dataRange,6);
    time = data(dataRange,2);
    
    subplot(2,1,1)
    plot(time, refWave);
    subplot(2,1,2);
    plot(time, depWave );
    
    [mag, phase] = transferFuncFind( time, frequencies(i), refWave,...
        depWave );
    
    output(i,:) = [mean(tempData(:,1)) mag phase ];
end


% Plot for inspection
% subplot(1,2,1);
% title( file );
% plot(1:size(data,1),data(:,6),pks(:,1),pks(:,2),'r.',troughs(:,1),troughs(:,2),'b.')
% 
% subplot(1,2,2);
% scatter(output(:,1), output(:,2), 50, 'r', 'filled');
% try
%     axis([0 frequencies(end)+5 0 max(output(:,2))*1.05]);
% end
% xlabel('Frequency (Hz)');
% ylabel('Peak-to-Peak Voltage (V_p_p)');
% 
% % Bode Plot
% bodePlot( output(:,1), output(:,2), output(:,3) );

end

