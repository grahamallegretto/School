function phase = phaseShiftFind( wave1, wave2, wavePeriod, sampleFreq )
%PHASESHIFTFIND Summary of this function goes here
%   Detailed explanation goes here

samplePointsFullCycle = floor(wavePeriod*sampleFreq);

% Normalize wave forms
wave1 = wave1 - mean(wave1);
wave2 = wave2 - mean(wave2);
timeIdx = 1:size(wave1,1);

% Cross correlation and addition of 
[r,lags] = xcorr( wave1, wave2, floor(samplePointsFullCycle/2) );
[~,shiftIdx] = max(r);
lag = lags(shiftIdx);

phase = (lag/samplePointsFullCycle)*360;
if phase > 0
    phase = phase - 360;
end
end

