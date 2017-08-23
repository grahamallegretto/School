function out = bodePlotSimulation2( fRange, Rl, SAOffset, SAAmp, Vdl, model, varargin )
%BODEPLOT Summary of this function goes here
%   Detailed explanation goes here

out = zeros(size(fRange,2),3);
out(:,1) = fRange';

for i = 1:size(fRange,2)
    
    if strcmp( model, 'lin' )
        [out(i,2), out(i,3)] = linearModel( fRange(i), Rl, ...
            SAOffset, SAAmp, Vdl, varargin{:} );
    else
        [time, SA, v] = EDLSimulation('sine', 'Rl', Rl, 'Vbias', Vdl, ...
            'f', fRange(i), 'toPlot', false, 'Vbias', Vdl, ...
            'SAOffset', SAOffset, 'SAAmp', SAAmp, 'toPlot', false, varargin{:} );
        out(i,2) = amplitudeFind(v);    
        out(i,3) = phaseShiftFind(SA,v,1/fRange(i),1/(time(2)-time(1)));
    end
end

end

