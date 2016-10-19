function out = bodePlotSimulation( fRange, Rl )
%BODEPLOT Summary of this function goes here
%   Detailed explanation goes here

vPhase = zeros(size(fRange,2),1);
volts = zeros(size(fRange,2),1);
out = zeros(size(fRange,2),3);

for i = 1:size(fRange,2)
    [time, SA, v] = EDLSimulation('sine', Rl, 0.7, fRange(i), false );
    vPhase(i) = phaseShiftFind(SA,v,1/fRange(i),1/(time(2)-time(1)));
    volts(i) = amplitudeFind(v);   
end

bodePlot( fRange, volts, vPhase );
out(:,1) = fRange;
out(:,2) = volts.*1000;
out(:,3) = vPhase;

end

