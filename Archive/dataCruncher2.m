function dataCruncher2( file, vDeadband, frequencies, dataColumn, fDeadband  )
%DATACRUNCHER Summary of this function goes here
%   Detailed explanation goes here

% Argument for separating data points based on their frequency
if nargin < 5
    fDeadband = 0.1;
end

% Read in data
data = headerIgnoreCSVRead( file );
data = data(:,[2 dataColumn]);

% Normalize data
avg = mean(data(:,2));
data(:,2) = data(:,2) - avg;
[pks, troughs] = findPeaks( data(:,2), vDeadband );

% Concactenize troughs and peaks
maximin = [troughs; pks];
[~,idx] = sort(maximin(:,1));
maximin = maximin(idx,:);

% Determine the time between peaks for sorting
halfPeriod = diff( data(maximin(:,1),1) );
freq = 1./(2.*halfPeriod);

% Separate the data based on frequencies
output = zeros(size(frequencies,2),2);
reducedMaximin = [];
for i = 1:size(frequencies,2)
    dB = frequencies(i)*fDeadband;
    tempData = maximin(abs(freq-frequencies(i)) < dB, :);    
    
    % Ignore the first portion of the data points and the last
    startIgnoreSpan = floor( size(tempData,1)*(1/4) );
    endIgnoreSpan = floor( size(tempData,1)*0.1 );
    tempData = tempData( startIgnoreSpan:end-endIgnoreSpan,:);
      
    averagePeak = mean( tempData( tempData(:,2) > 0, 2 ) );
    averageTrough = mean( tempData( tempData(:,2) < 0, 2 ) );
    output(i,:) = [frequencies(i) averagePeak - averageTrough];
    reducedMaximin = [reducedMaximin; tempData];
end

% Plot for inspection
subplot(1,2,1);
title( file );
plot(1:size(data,1),data(:,2),reducedMaximin(:,1),reducedMaximin(:,2),'r.')

subplot(1,2,2);
scatter(output(:,1), output(:,2), 50, 'r', 'filled');
try
    axis([0 frequencies(end)+5 0 max(output(:,2))*1.05]);
end
xlabel('Frequency (Hz)');
ylabel('Peak-to-Peak Voltage (V_p_p)');

end

