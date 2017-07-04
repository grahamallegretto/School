function [ measured ] = bodePlotRawData( folder_name, gainR, load, SAOffset, SAAmp, Vdl, model, varargin )
%BODEPLOTRAWDATA Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
    folder_name = pwd;
elseif isempty( folder_name )
    folder_name = uigetdir('C:\Users\Graham\Documents\MATLAB\Frequency Response\Data');
end

% First try old convention
try
    frequencies = logspace( -1, 2, 32 );
    Low = dataCruncher( [folder_name, '/logspace(-1 2 32)_100Hz_First.csv'], ...
        0.005, frequencies(1:12), 0.05);
    Mid = dataCruncher( [folder_name, '/logspace(-1 2 32)_1kHz_Second.csv'], ...
        0.005, frequencies(13:24), 0.05);
    High = dataCruncher( [folder_name, '/logspace(-1 2 32)_2p5kHz_Third.csv'], ...
        0.005, frequencies(25:end), 0.05);
catch
    frequencies = logspace( -1, 2, 36 );
    Low = dataCruncher( [folder_name, '/logspace(-1 2 36)_100Hz_First.csv'], ...
        0.001, frequencies(1:12), 0.05);
    Mid = dataCruncher( [folder_name, '/logspace(-1 2 36)_1kHz_Second.csv'], ...
        0.001, frequencies(13:24), 0.05);
    High = dataCruncher( [folder_name, '/logspace(-1 2 36)_2p5kHz_Third.csv'], ...
        0.001, frequencies(25:end), 0.05);
end

measured = [Low; Mid; High];

% Compensate for gain
if (nargin > 1) && (gainR ~= 1)
    gain = ( 6000 + gainR ) / gainR
    measured(:,2) = measured(:,2) ./ gain;
end

if nargin > 2
    simuled = bodePlotSimulation( frequencies, load, SAOffset, SAAmp, Vdl, model, varargin{:} );

    % Take care of issue where you have the phase switching sides
    for i = 2:size(frequencies,2)
        if( abs(measured(i,3) - measured(i-1,3)) > 100 )
            measured(i,3) = measured(i,3) - 360;
        end
    end

    close all;

    bodePlot2(measured(:,1),measured(:,2),measured(:,3),...
        simuled(:,1),simuled(:,2),simuled(:,3))
else
    bodePlot( measured(:,1), measured(:,2), measured(:,3) );
end

end

