function ODE45_EDLSimulation( SAData )
%EDLSIMULATION Simulates the voltage response of the EDL energy harvester
%based on the surface area of the top electrode
%   Detailed explanation goes here

close all;

%% Parameters and Constants &&
epsilon = 8.854e-12;    % Permitivity of free space

% Specifying Parameters
Rf = 10^5;           % Resistance of electrolyte
                     % R = lp/A = (1.5mm * 20MOhm/mm)/15mm^2
Rl = 10^5;           % Load resistance

% Capacitance Parameters
EDLBiasVoltage = 0.1; % The generated voltage across the EDL
ep = 2.1;           % Dielectric Constant of PTFE
ed = 78;            % Dielectric Constant of Water droplet
lambdaD = 300e-9;   % Debye length of water droplet (m)
dPTFE = 300e-9;     % Thickness of PTFE Layer (m)

% Surface Area Signal
f  = 5;             % Frequency of modulation (Hz)
Amax = 17.5;        % Max surface area (mm^2)
Amin = 2.5;         % Min surface area (mm^2)
Abottom = 28;       % Bottom surface area (mm^2)

%% Initial Calculations %%

% Generate Surface Area Signal if it isn't passed in as a parameter
if nargin == 0
    dt = 0.0001;           % Delta T
    timeLength = 1;     % Length of time to run the simulation
    
    % Sine Wave
    square = false;
    time = 0:dt:timeLength;
    SAoffset = ((Amax - Amin) / 2) + Amin;
    SAamp = (Amax - Amin) / 2;
    SA = ( SAamp .* sin( (2*pi*f).*time ) + SAoffset )';

    % Step response
    SA = zeros(size(time,2),1);
    SA(1:end) = Amin;
    SA( floor(size(SA,1)/2):end, 1 ) = Amax;
    square = true;
else
    dt = SAData(2,1) - SAData(1,2);
    Amax = max( SAData(:,2) );
    Amin = min( SAData(:,2) );
    SAoffset = ((Amax - Amin) / 2) + Amin;
    
    time = SAData(:,1);
    SA = SAData(:,2);
end

% Constant values
Rprime = (Rf + Rl)/dt;                          % Used in the simulation
Cb = (epsilon * ed * Abottom * 1e-6) / lambdaD; % Bottom capacitance
CtPerArea = (epsilon * ep * 1e-6) / dPTFE;      % Capacitance of the top electrode without the area component (F/mm^2)
Ct = CtPerArea.*SA;                             % Top Electrode Capacitance as a function of surface area

% Initial Charge Calculation
    % Assuming at the beginning that there is no current flow, therefore 
    %           Qb/Cb = Qt/Ct = EDLBiasVoltage
    % Charge at each EDL can be calculated
Qb = EDLBiasVoltage * Cb;

if square 
    Qt = EDLBiasVoltage * CtPerArea * Amin;
else
    Qt = EDLBiasVoltage * CtPerArea * SAoffset;
end

tic;
options = odeset('RelTol',1e-10,'AbsTol',1e-12);
[t,y] = ode45(@(t,y) chargeFunc( t, y, time, Ct, Cb, Rf+Rl, Qb, Qt ), [0 timeLength], 0, options);
timeSpent = toc

SA = interp1( time, SA, t );
plotyy(t,y,t,SA);
end
