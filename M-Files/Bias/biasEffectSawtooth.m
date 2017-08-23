function subIntervals = biasEffectSawtooth( data, period, numSaws )
%BIASEFFECT Summary of this function goes here
%   Detailed explanation goes here

close all
data = headerIgnoreCSVRead( data );

sawInterval = floor( size(data,1) / numSaws );
subIntervals = zeros( floor( sawInterval / (period*1000)), 3, numSaws );

for i = 1:numSaws
    startInterval = (i-1)*sawInterval + 1;
    endInterval = i*sawInterval;
    
    subIntervals(:,:,i) = ...
        biasEffect( data(startInterval:endInterval, :), period );
end

plotMultiBias( subIntervals, 2 );

end



