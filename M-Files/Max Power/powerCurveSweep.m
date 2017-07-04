function powerCurveSweep( resistors, frequencies, SAOffset, SAAmp, Vdl, gain, folderName )
%POWERCURVESWEEP Performs power curve over multiple frequencies.
%   Detailed explanation goes here

close all

% If filename is passed in, ignore this, if not, find the folder using a
% dialog
if ( nargin < 7 )
    folderName = uigetdir('C:\Users\Graham\Documents\MATLAB\Max Power');
end

% Determine the resistance based on the resistors that are installed on the
% load control board
if size( resistors, 2 ) == 5
    [resistors, ~] = resistorSearch( resistors );
end

% Preallocate memory
avgPower    = zeros( size(resistors,1), size(frequencies,2) );
pkPower     = zeros( size(resistors,1), size(frequencies,2) );
avgPowerSim = zeros( size(resistors,1), size(frequencies,2) );
pkPowerSim  = zeros( size(resistors,1), size(frequencies,2) );

% Determine power output sweep for each frequency
figure
% sub1 = subplot(1,2,1);
% hold(sub1, 'on');
% sub2 = subplot(1,2,2);
% hold(sub2, 'on');
hold on
for i = 1:size(frequencies,2) 
   
   % Open the correct file
   data = headerIgnoreCSVRead( [folderName, '\', num2str(frequencies(i)), 'Hz Load Test.csv'] );
   data(:,6) = data(:,6) / gain;
   
   % Run Power Curve to determine power
    [pkPower(:,i), avgPower(:,i), pkPowerSim(:,i), avgPowerSim(:,i)] = ...
        powerCurve( data, resistors, frequencies(i), SAOffset, SAAmp, Vdl, false );

   % Max power resistance
    w = 2*pi*frequencies(i);
    Ct = capMeasurement(SAOffset);
    dCt = capMeasurement(SAAmp);
    Rf = 70000;
    maxPowRes = sqrt( (1 / (w*Ct)^2) + Rf^2);
    maxPow = powerLinear( Ct, dCt, Rf, maxPowRes, Vdl, w );
    
    powLin = size( resistors, size(frequencies,2) );   
    for j = 1:size( resistors )
        powLin(j,i) = powerLinear( Ct, dCt, Rf, resistors(j), Vdl, w );
    end
    
    h(i) = plot( resistors, avgPower(:,i) );
    plot( maxPowRes, maxPow, '*');

%   % For Resistor Overlay Plot
%     plot( resistors(5:end), avgPower(5:end,i), '*');
%     h(i) = plot( resistors(5:end), avgPowerSim(5:end,i) );    
end
legend( h(:), '10 Hz', '15 Hz', '20 Hz', '25 Hz', '30 Hz'); 



hold off;

