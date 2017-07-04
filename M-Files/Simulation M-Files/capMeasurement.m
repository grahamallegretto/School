function Ct = capMeasurement( SA )
%CAPMEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

dPTFE = 30e-9;          % Thickness of PTFE Layer (m)
ep = 1.93;              % Dielectric Constant of PTFE
epsilon = 8.854e-12;    % Permitivity of free space

Ct = (epsilon * ep * 1e-6 * SA) / dPTFE;

end

