function [time, SA, v, VlinOut] = EDLSimulation2( SAName, varargin )
%EDLSIMULATION Simulates the voltage response of the EDL energy harvester
%based on the surface area of the top electrode
    % SAName - Filename of Bose Data (Must be in proper format)
    % Rl - Load Resistor
    % EDLBiasVoltage - Voltage generated from formation of Double Layer
    % toPlot - Set to true if you want plots

%% Constants %%
ep = 1.93;              % Dielectric Constant of PTFE
ed = 78;                % Dielectric Constant of Water droplet
lambdaD = 150e-9;       % Debye length of water droplet (m)

%% Parameter Defaults %%
epsilon = 8.854e-12;    % Permitivity of free space

% Default Values for parameters
defaultRf = 70000;          % Resistance of electrolyte
                            % R = lp/A = (1.5mm * 20MOhm/mm)/15mm^2                    
defaultRl = 10e6;           % Load resistance
defaultVbias = 0.7;         % The generated voltage across the EDL
defaultPTFE = 30e-9;        % Thickness of PTFE Layer (m)
defaultF = 1;               % Frequency of modulation (Hz)
defaultAbottom = 50;        % Bottom surface area (mm^2)
defaultUpConFactor = 10;    % Upconversion factor
defaultNumSamples = 100000; % Number of samples for artificial signals
defaultNumCycles = 5;       % Length of time to run the simulation
defaultSAOffset = 27;       % Average surface area (mm^2)
defaultSAAmp = 13.5;        % Amplitude of surface area signal (mm^2)
defaultToPlot = true;       % Whether or not to plot
defaultCloseAll = true;     % Whether or not to close all windows

p = inputParser;
addRequired(p,'SAName',@ischar);
addParameter(p,'Rf',defaultRf,@isnumeric);
addParameter(p,'Rl',defaultRl,@isnumeric);
addParameter(p,'Vbias',defaultVbias,@isnumeric);
addParameter(p,'dPTFE',defaultPTFE,@isnumeric);
addParameter(p,'f',defaultF,@isnumeric);
addParameter(p,'Abottom',defaultAbottom,@isnumeric);
addParameter(p,'upConFactor',defaultUpConFactor,@isnumeric);
addParameter(p,'numSamples',defaultNumSamples,@isnumeric);
addParameter(p,'numCycles',defaultNumCycles,@isnumeric);
addParameter(p,'SAOffset',defaultSAOffset,@isnumeric);
addParameter(p,'SAAmp',defaultSAAmp,@isnumeric);
addParameter(p,'toPlot',defaultToPlot,@islogical);
addParameter(p,'closeAll',defaultCloseAll,@islogical);
parse(p,SAName,varargin{:})

SAName = p.Results.SAName;
Rf = p.Results.Rf;
Rl = p.Results.Rl;
Vbias = p.Results.Vbias;
dPTFE = p.Results.dPTFE;
f = p.Results.f;
Abottom = p.Results.Abottom;
upConFactor = p.Results.upConFactor;
numSamples = p.Results.numSamples;
numCycles = p.Results.numCycles;
SAOffset = p.Results.SAOffset;
SAAmp = p.Results.SAAmp;
toPlot = p.Results.toPlot;
closeAll = p.Results.closeAll;
    
if closeAll
    close all
end

%% Surface Area Signal %%
% Can either be a signal that is passed in as a parameter or a step or sine
% wave generated based on the constants listed above,
dt = (numCycles*(1/f) ) / numSamples;       % Delta T
time = 0:dt:numCycles*(1/f);                % Time
Amax = SAOffset + SAAmp;
Amin = SAOffset - SAAmp;

if size(SAName,2) == 4
    
    % Sine Wave
    if strcmp(SAName, 'sine')
        SA = ( SAAmp .* sin( (2*pi*f).*time ) + SAOffset )';

    % Step Response
    elseif strcmp(SAName, 'step')
        SA = zeros(size(time,2),1);
        SA(1:end) = Amin;
        SA( floor(size(SA,1)/2):end, 1 ) = Amax;
    end
    
    % If data is passed in
else
    % Read in data
    SAData = headerIgnoreCSVRead( SAName );
    SAData = SAData(:,[2 4 6]);
    
    % Since the data we're using from the BOSE machine is in displacement we
    % need to convert it to surface area.
    SAData(:,2) = SAData(:,2) -  mean(SAData(:,2));

    AGain = SAAmp / max( SAData(:,2) );
    SAData(:,2) = (-1.*AGain.*SAData(:,2)) + (SAOffset - mean(SAData(:,2)));

    SADataTemp(:,1) = interp(SAData(:,1),upConFactor);
    SADataTemp(:,2) = interp(SAData(:,2),upConFactor);
    
    dt = SADataTemp(2,1) - SADataTemp(1,1);
    time = SADataTemp(:,1);
    SA = SADataTemp(:,2);
end

%% Double Layer Constants and Calculations %%
%
% Constant values
Rprime = (Rf + Rl)/dt;                          % Used in the simulation
Cb = (epsilon * ed * Abottom * 1e-6) / lambdaD; % Bottom capacitance
CbR = Cb*Rprime;                                % Intermediate value
CtPerArea = (epsilon * ep * 1e-6) / dPTFE;      % Capacitance of the top electrode without the area component (F/mm^2)
Ct = CtPerArea .* SA;

% Initial Charge Calculation
    % Assuming at the beginning that there is no current flow, therefore 
    %           Qb/Cb = Qt/Ct = EDLBiasVoltage
    % Charge at each EDL can be calculated
Qb = Vbias * Cb;
Qt = Vbias * Ct(1);

% Linear Model
C = (Ct(1)*Cb)/(Ct(1)+Cb);
CtMin = Amin*CtPerArea;
dCt = Ct(1)-CtMin;
dq = Vbias*dCt;%((CtMin*Qb) - (Qt*Cb)) / (Cb+CtMin);



%% Simulation %%
% Perform the simulation
q = zeros(size(SA));
Vlin = zeros(size(SA));
VlinOut = zeros(size(SA));

Ilin = 2*pi*f*Vbias*(SAAmp/SAOffset)*dt;
linearTemp = (1-(dt/C)*(1/(Rl+Rf)));
vDivider = Rl/(Rl+Rf);

for i = 1:size(SA,1)-1
    
    q(i+1) =   ( (Qb-q(i)) / (CbR) ) ...
            -  ( (Qt+q(i)) / (Ct(i)*Rprime) )...
            +  q(i);
    
    Vlin(i+1) =   Vlin(i)*linearTemp + Ilin*cos(2*pi*f*time(i));
    VlinOut(i+1) = Vlin(i+1)*vDivider;
        
    % If the next charge is less than the relative accuracy of floating
    % point numbers, just set it to 0. If you don't, the simulation
    % explodes Ahhhhh!
    if abs( q(i+1) ) < eps
        q(i+1) = 0;
    end
   
end
dqdt = diff(q)./dt;
v = (((Qb-q)/Cb) - ((Qt+q)./Ct)).*( Rl / ( Rf+Rl ));

%% Plot The Data %%

% Plot for self generated Sine/Step Waves
if (size(SAName,2) == 4) && toPlot

    subPlotModified( time, SA, v, VlinOut, '', 'Time (s)','Surface Area (mm^2)', ...
        'Voltage (V)', 'Non-Linear Model Response', 'Linear Model Response');
    
% Plot for Bose Data
elseif toPlot
    subplot(2,1,1);
    plot(time, SA);
    title('Surface Area Plot');
    axis([0 time(end) -inf inf]);
    xlabel('Time (s)');
    ylabel('Surface Area (mm^2)');
    
    subplot(2,1,2);
    plot( SAData(:,1), -1.*SAData(:,3), time, v );
    title('Voltage Response');
    legend('Measured','Simulated');
    axis([0 time(end) -inf inf]);
    xlabel('Time (s)');
    ylabel('Voltage (V)');
end

end
