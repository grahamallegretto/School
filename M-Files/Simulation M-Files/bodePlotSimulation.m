function out = bodePlotSimulation( fRange, Rl, SAOffset, SAAmp )
%BODEPLOT Summary of this function goes here
%   Detailed explanation goes here

vPhase = zeros(size(fRange,2),1);
volts = zeros(size(fRange,2),1);
out = zeros(size(fRange,2),3);
outLinear = zeros(size(fRange,2),3);

CbPerArea = 4.6041e-09;
CtPerArea = 5.6961e-10;
ABottom = 100;
Rf = 70000;

Cb = CbPerArea*ABottom;
dCt = SAAmp*CtPerArea;
CtOffset = SAOffset*CtPerArea;

for i = 1:size(fRange,2)
    [time, SA, v] = EDLSimulation('sine', 'Rl', Rl, 'Vbias', 0.7, ...
        'f', fRange(i), 'toPlot', false, 'Abottom', ABottom, ...
        'SAOffset', SAOffset, 'SAAmp', SAAmp, 'numCycles', 30, ...
        'toPlot', false, 'Rf', Rf );
    vPhase(i) = phaseShiftFind(SA,v,1/fRange(i),1/(time(2)-time(1)));
    volts(i) = amplitudeFind(v);    
    
    [mag, phase] = linearModel( 0.7, dCt, CtOffset, Rl, fRange(i), Rf );
    outLinear(i,1) = fRange(i);
    outLinear(i,2) = mag;
    outLinear(i,3) = phase;
end

bodePlot2( fRange, volts, vPhase, outLinear(:,1), outLinear(:,2), outLinear(:,3) );
out(:,1) = fRange;
out(:,2) = volts;
out(:,3) = vPhase;

end

