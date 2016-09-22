function [time, SA, v] = EDLSimulation( SAName, Rl, EDLBiasVoltage, f, toPlot )
%EDLSIMULATION Simulates the voltage response of the EDL energy harvester
%based on the surface area of the top electrode
    % SAName - Filename of Bose Data (Must be in proper format)
    % Rl - Load Resistor
    % EDLBiasVoltage - Voltage generated from formation of Double Layer
    % toPlot - Set to true if you want plots

close all;

%% Parameters and Constants &&
epsilon = 8.854e-12;    % Permitivity of free space

% Specifying Parameters
Rf = 70000;             % Resistance of electrolyte
                    	% R = lp/A = (1.5mm * 20MOhm/mm)/15mm^2
if exist('Rl','var') == 0                         
    Rl = 10e6;              % Load resistance
end

% Capacitance Parameters
if exist('EDLBiasVoltage','var') == 0    
    EDLBiasVoltage = 0.7;   % The generated voltage across the EDL
end
ep = 1.93;              % Dielectric Constant of PTFE
ed = 78;                % Dielectric Constant of Water droplet
lambdaD = 150e-9;       % Debye length of water droplet (m)
dPTFE = 30e-9;          % Thickness of PTFE Layer (m)

% Surface Area Signal
if exist('f','var') == 0    
    f  = 1;                 % Frequency of modulation (Hz)
end
Amax = 19.57;           % Max surface area (mm^2)
Amin = 9.3;             % Min surface area (mm^2)
Abottom = 28;           % Bottom surface area (mm^2)
dt = 0.0001;            % Delta T
numCycles = 4;          % Length of time to run the simulation
time = 0:dt:numCycles*(1/f); % Time
upConFactor = 10;       % Upconversion factor
    
%% Surface Area Signal %%
% Can either be a signal that is passed in as a parameter or a step or sine
% wave generated based on the constants listed above
SAOffset = ((Amax - Amin) / 2) + Amin;
SAamp = (Amax - Amin) / 2;

if size(SAName,2) == 4
    
    % Sine Wave
    if strcmp(SAName, 'sine')
        SA = ( SAamp .* sin( (2*pi*f).*time ) + SAOffset )';

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
    AGain = SAamp / max( SAData(:,2) );
    SAData(:,2) = (AGain.*SAData(:,2)) + (SAOffset - mean(SAData(:,2)));
    
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
Qb = EDLBiasVoltage * Cb;
Qt = EDLBiasVoltage * Ct(1);


%% Simulation %%
% Perform the simulation
q = zeros(size(SA));

for i = 1:size(SA,1)-1
    
    q(i+1) =   ( (Qb-q(i)) / (CbR) ) ...
            -  ( (Qt+q(i)) / (Ct(i)*Rprime) )...
            +  q(i);
    
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

if exist('toPlot','var') == 0                         
    toPlot = true;              % Load resistance
end

% Plot for self generated Sine/Step Waves
if (size(SAName,2) == 4) && toPlot
    plotyy(time, SA, time, v);
    
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
