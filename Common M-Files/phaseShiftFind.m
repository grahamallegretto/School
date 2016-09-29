function phase = phaseShiftFind( wave1, wave2, wavePeriod, sampleFreq )
%PHASESHIFTFIND Summary of this function goes here
%   Detailed explanation goes here

samplePointsFullCycle = floor(wavePeriod*sampleFreq);

wave1 = wave1 - mean(wave1);
wave2 = wave2 - mean(wave2);
timeIdx = 1:size(wave1,1);

[acor,lags] = xcorr( wave1, wave2, floor(samplePointsFullCycle/2) );
[~,shiftIdx] = max(acor);
lag = lags(shiftIdx);

phase = (lag/samplePointsFullCycle)*360;
if phase > 180
    phase = phase - 360;
elseif phase < -180
    phase = phase + 360;
end

% subplot(3,1,1);
% plotyy(timeIdx,wave1,timeIdx,wave2);
% subplot(3,1,2);
% plot(lags,acor);
% subplot(3,1,3);
% time = 1:size(wave1,1);
% plotyy(time,wave1,time,circshift(wave2,lag));

end