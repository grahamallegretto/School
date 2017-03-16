function [ measured ] = bodePlotRawData( frequencies, load, SAOffset, SAAmp )
%BODEPLOTRAWDATA Summary of this function goes here
%   Detailed explanation goes here

folder_name = uigetdir;

Low = dataCruncher( [folder_name, '/logspace(-1 2 32)_100Hz_First.csv'], ...
    0.005, frequencies(1:12), 0.05);
Mid = dataCruncher( [folder_name, '/logspace(-1 2 32)_1kHz_Second.csv'], ...
    0.005, frequencies(13:24), 0.05);
High = dataCruncher( [folder_name, '/logspace(-1 2 32)_2p5kHz_Third.csv'], ...
    0.005, frequencies(25:end), 0.05);

measured = [Low; Mid; High];
simuled = bodePlotSimulation( frequencies, load, SAOffset, SAAmp );

% Take care of issue where you have the phase switching sides
for i = 2:size(frequencies,2)
    if( abs(measured(i,3) - measured(i-1,3)) > 100 )
        measured(i,3) = measured(i,3) - 360;
    end
end

close all;

bodePlot2(measured(:,1),measured(:,2),measured(:,3),...
    simuled(:,1),simuled(:,2),simuled(:,3))

end

