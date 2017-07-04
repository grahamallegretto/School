function freqDomainModelCompare()
%FREQDOMAINMODELCOMPARE Summary of this function goes here
%   Detailed explanation goes here

close all
% win(1) = subplot(2,1,1);
%     grid on
%     title( 'Magnitude Response' );
%     xlabel( 'Frequency (Hz)' );
%     ylabel( 'Amplitude' );
%     set( win(1), 'XScale', 'log' );
%     set( win(1), 'YScale', 'log' );
%     hold on
%     
% win(2) = subplot(2,1,2);
%     grid on
%     title( 'Phase Response' );
%     xlabel( 'Frequency (Hz)' );
%     ylabel( 'Phase (Degree)' );
%     set( win(2), 'XScale', 'log' );
%     hold on


lin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 2, 0.3, 'lin' );
plot( lin(:,1), lin(:,2), '-.', 'Color', 'm' );
%plot( win(2), lin(:,1), lin(:,3), '-.', 'Color', 'm' );
grid on
title( 'Magnitude Response' );
xlabel( 'Frequency (Hz)' );
ylabel( 'Amplitude' );
set( gca, 'XScale', 'log' );
set( gca, 'YScale', 'log' );
hold on

lin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 2, 0.3, 'lin' );
plot( lin(:,1), lin(:,2), '-.', 'Color', 'm', 'LineWidth', 1 );
%plot( win(2), lin(:,1), lin(:,3), '-.', 'Color', 'r' );

lin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 4, 0.3, 'lin' );
plot( lin(:,1), lin(:,2), '-.', 'Color', 'r', 'LineWidth', 1 );
%plot( win(2), lin(:,1), lin(:,3), '-.', 'Color', 'r' );

lin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 8, 0.3, 'lin' );
plot( lin(:,1), lin(:,2), '-.', 'Color', 'g', 'LineWidth', 1 );
%plot( win(2), lin(:,1), lin(:,3), '-.', 'Color', 'g' );

lin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 16, 0.3, 'lin' );
h4 = plot( lin(:,1), lin(:,2), '-.', 'Color', 'b', 'LineWidth', 1 );
%plot( win(2), lin(:,1), lin(:,3), '-.', 'Color', 'b' );

% Non Lin
nonlin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 2, 0.3,...
    'nlin', 'closeAll', false );
h1 = plot( nonlin(:,1), nonlin(:,2), 'Color', 'm', 'LineWidth', 1 );
%plot( win(2), nonlin(:,1), nonlin(:,3), 'Color', 'm' );

nonlin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 4, 0.3,...
    'nlin', 'closeAll', false );
h2 = plot( nonlin(:,1), nonlin(:,2), 'Color', 'r', 'LineWidth', 1 );
%plot( win(2), nonlin(:,1), nonlin(:,3), 'Color', 'r' );

nonlin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 8, 0.3,...
    'nlin', 'closeAll', false );
h3 = plot( nonlin(:,1), nonlin(:,2), 'Color', 'g', 'LineWidth', 1 );
%plot( win(2), nonlin(:,1), nonlin(:,3), 'Color', 'g' );

nonlin = bodePlotSimulation( logspace( -1, 2, 36 ), 10e6, 20, 16, 0.3,...
    'nlin', 'closeAll', false );
h4 = plot( nonlin(:,1), nonlin(:,2), 'Color', 'b', 'LineWidth', 1 );
%plot( win(2), nonlin(:,1), nonlin(:,3), 'Color', 'b' );

legend( [h1 h2 h3 h4], {'10%','20%','40%','80%'} );

end

