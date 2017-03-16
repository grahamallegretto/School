function [ mag, phase ] = linearModel( Vdl, dCt, CtOffset, Rl, f, Rf )
%LINEARMODEL Summary of this function goes here
%   Detailed explanation goes here

mag = abs( (       2*pi*f*Vdl*dCt*Rl) ...
      /sqrt(1 + (2*pi*f)^2*(Rl+Rf)^2*CtOffset^2) );

phase = (180/pi)*atan(1/(2*pi*f*(Rl+Rf)*CtOffset));

end

