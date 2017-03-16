function phase = phaseShiftFind( wave1, wave2, wavePeriod, sampleFreq )
%PHASESHIFTFIND Uses correlation to determine the phase shift between two
%waves
%   wave1: Reference wave
%   wave2: Wave were phase shift is calculated

% Determine how many data points there are for a full period for the
% correlation function such that there will only be one peak.
samplePointsFullCycle = floor(wavePeriod*sampleFreq);

% If the two waves aren't the same size, resize the larger one to avoid an
% error
if size(wave1,1) > size(wave2,1)
    wave1 = wave1(1:size(wave2,1));
else
    wave2 = wave2(1:size(wave1,1));
end

% Normalize data such that they are about zero
wave1 = wave1 - mean(wave1);
wave2 = wave2 - mean(wave2);
timeIdx = 1:size(wave1,1);

% Perform the correlation function and get the maximum value 
[acor,lags] = xcorr( wave1, wave2, floor(samplePointsFullCycle/2) );
[~,shiftIdx] = max(acor);
lag = lags(shiftIdx);

% Convert to degrees
phase = (lag/samplePointsFullCycle)*360;

if phase >= 180
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
% waitforbuttonpress();

end