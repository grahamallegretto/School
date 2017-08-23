function subIntervals = biasEffectLiftOffSawtooth( data, period, numTeeth, numSaws, startPoints )
%BIASEFFECT Summary of this function goes here
%   Detailed explanation goes here

close all
data = headerIgnoreCSVRead( data );

toothLength = numTeeth*period*1000;
saw = zeros( toothLength, 7, numSaws );
subIntervals = zeros( numTeeth, period, numSaws );

if ~exist( 'startPoints', 'var' )
    startPoints = [5622, 71820, 137900, 204000, 269400, size(data,1)-60002];
end

for i = 1:numSaws
    saw(:,:,i) = data(startPoints(1,i):startPoints(1,i)+toothLength-1,:);
    subIntervals(:,:,i) = biasEffect( saw(:,:,i), period );
end

plotMultiBias( subIntervals, 0 );

end



