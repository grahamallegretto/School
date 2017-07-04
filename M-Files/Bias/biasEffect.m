function [vOffset, vAmp, phase] = biasEffect( data, numIntervals, plotOn )
%BIASEFFECT Summary of this function goes here
%   Detailed explanation goes here

close all

% If filename is passed in
if ischar(data) 
    data = headerIgnoreCSVRead( data );
end

% Check if variables exist
if ~exist( 'numIntervals', 'var' )
    numIntervals = floor( size(data, 1) / 5000 );  
end
if ~exist( 'plotOn', 'var' )
    plotOn = false;
end

intervalLeng = floor( size(data, 1) / numIntervals );
vOffset = zeros(numIntervals,1);
vAmp = zeros(numIntervals,1);
phase = zeros(numIntervals,1);


if plotOn 
    hold on;
    plot( data(:,2), data(:,6) );
end

for i = 1:numIntervals
    % Interval within the data for a given resistance
    rawRangeStart = (intervalLeng * (i-1)) + 1;
    rawRangeEnd = intervalLeng * i;
    
    % Allow for time for the the output to normalize
    rangeStart = rawRangeStart + floor(intervalLeng * 0.2);
    rangeEnd = rawRangeEnd - floor(intervalLeng * 0.2);
    biasInterval = rangeStart:rangeEnd;
    
    vOffset(i) = mean( data(biasInterval,6) );
    [pks, troughs] = findPeaks( data(biasInterval, 6), 0.001 );
    
    % Eliminate the first and last peak and trough so that it doesn't get
    % the edges
    pks = pks(2:end-1,:);
    troughs = troughs(2:end-1,:);
    
    % Plot Intervals
    if plotOn
        plot( [data(rangeEnd,2), data(rangeEnd,2)], ...
            [data(rangeEnd,6)+1, data(rangeEnd,6)-1], 'r' );
        plot( [data(rangeStart,2), data(rangeStart,2)], ...
            [data(rangeStart,6)+1, data(rangeStart,6)-1], 'g' );
    end
    
    % Determine peak to peak and phase
    vAmp(i) = (mean(pks(:,2)) - mean(troughs(:,2)))/2;
    phase(i) = phaseShiftFind(-1.*data(biasInterval,4),...
        data(biasInterval,6),0.2,1/(data(2,2)-data(1,2)));
end

figure
subplot(2,1,1);
plot( vOffset, vAmp );
subplot(2,1,2);
plot( vOffset, phase );

end


%     %Plot for inspection
%     plot(biasInterval-rangeStart,data(biasInterval,6),pks(:,1),pks(:,2),'r.',troughs(:,1),troughs(:,2),'b.');
%     hold on
%     plot( [0, rangeEnd-rangeStart], [vOffset(i) vOffset(i)], 'r');
%     plot( [size(biasInterval,2)/2, size(biasInterval,2)/2], ...
%         [vOffset(i) + vPP(i)/2, vOffset(i) - vPP(i)/2] );
%     hold off
%     waitforbuttonpress();
