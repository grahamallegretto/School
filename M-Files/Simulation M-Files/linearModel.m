function [ mag, phase ] = linearModel( f, Rl, SAOffset, SAAmp, Vbias, varargin )
%LINEARMODEL Summary of this function goes here
%   Detailed explanation goes here

%% Parameter Defaults %%
epsilon = 8.854e-12;    % Permitivity of free space
ep = 1.93;              % Dielectric Constant of PTFE

% Default Values for parameters
defaultRf = 70000;          % Resistance of electrolyte
                            % R = lp/A = (1.5mm * 20MOhm/mm)/15mm^2                    
defaultPTFE = 30e-9;        % Thickness of PTFE Layer (m)

p = inputParser;
addParameter(p,'Rf',defaultRf,@isnumeric);
addParameter(p,'dPTFE',defaultPTFE,@isnumeric);
parse(p,varargin{:})
Rf = p.Results.Rf;
dPTFE = p.Results.dPTFE;

CtPerArea = (epsilon * ep * 1e-6) / dPTFE;      % Capacitance of the top electrode without the area component (F/mm^2)
CtOffset = CtPerArea .* SAOffset;
dCt = CtPerArea .* SAAmp;

mag = abs( (       2*pi*f*Vbias*dCt*Rl) ...
      /sqrt(1 + (2*pi*f)^2*(Rl+Rf)^2*CtOffset^2) );

phase = (180/pi)*atan(1/(2*pi*f*(Rl+Rf)*CtOffset));

end

