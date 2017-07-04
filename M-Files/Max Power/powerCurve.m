function [ pkPower, avgPower, pkPowerSim, avgPowerSim ] = powerCurve( data, resistors, f, SAOffset, SAAmp, Vdl, plotOn )
%POWERCURVE Analyzes data from arduino
%   Detailed explanation goes here

% If filename is passed in
if ischar(data) 
    data = headerIgnoreCSVRead( data );
end

if ~exist('plotOn','var')
    plotOn = false;
end

% Determine the resistance based on the resistors that are installed on the
% load control board
if size( resistors, 2 ) == 5
    [resistors, ~] = resistorSearch( resistors );
end
avgPower = zeros( size(resistors,1), 1 );
pkPower  = zeros( size(resistors,1), 1 );
avgPowerSim = zeros( size(resistors,1), 1 );
pkPowerSim  = zeros( size(resistors,1), 1 );

% Split up the data into chunks based on the number of resistance values
intervalLeng = floor( size(data, 1) / size(resistors,1) );

for i = 1:size(resistors,1)
    % Interval within the data for a given resistance
    rangeStart = (intervalLeng * (i-1)) + 1;
    rangeEnd = intervalLeng * i;
    
    % Allow for time for the the output to normalize
    rangeStart = rangeStart + floor(intervalLeng * 0.25);
    frequencyInterval = rangeStart:rangeEnd;
        
    [ pkPower(i), avgPower(i), ~ ] = powerCalc( data( frequencyInterval,6 ), ...
        resistors(i) );

    % If there are enough arguments, add simulation data to it
    if( nargin > 2 )
        [~, ~, v] = EDLSimulation('sine', 'Rl', resistors(i), 'Vbias', Vdl, ...
        'f', f, 'toPlot', false, 'numSamples', 10000, 'SAOffset', SAOffset, ...
        'SAAmp', SAAmp, 'closeAll', false, 'numCycles', 40 );
        [ pkPowerSim(i), avgPowerSim(i), ~ ] = powerCalc( v, resistors(i) );
        
%         subplot(2,1,1);
%         plot( v );
%         subplot(2,1,2);
%         plot( data( frequencyInterval,6 ) );
    end
end

% Plot Data
if( plotOn )
    plot( resistors, avgPower, resistors, avgPowerSim );
    xlabel('Resistance');
end
