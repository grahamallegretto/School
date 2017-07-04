function avgPow = powerLinear( Ct, dCt, Rf, Rl, Vdl, w )
%POWERLINEAR Summary of this function goes here
%   Detailed explanation goes here

    avgPow = (1/2)*(Rl*(w*dCt*Vdl)^2)/(1+(w*Ct*(Rl+Rf))^2);

end

