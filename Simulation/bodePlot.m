function bodePlot( fRange )
%BODEPLOT Summary of this function goes here
%   Detailed explanation goes here

phases = zeros(size(fRange,2),1);
amplitudes = zeros(size(fRange,2),1);

for i = 1:size(fRange,2)
    [time, SA, v] = EDLSimulation('sine', 20e6, 0.7, fRange(i), false );
    phases(i) = phaseShiftFind(SA,v,1/fRange(i),1/(time(2)-time(1)));
    amplitudes(i) = amplitudeFind(v);
end

subplot(2,1,1);
loglog( fRange, amplitudes );
grid on
title( 'Magnitude Response' );
xlabel( 'Frequency (Hz)' );
ylabel( 'Amplitude (V)' );

subplot(2,1,2);
semilogx( fRange, phases );
grid on
title( 'Phase Response' );
xlabel( 'Frequency (Hz)' );
ylabel( 'Phase (Degree)' );

end

