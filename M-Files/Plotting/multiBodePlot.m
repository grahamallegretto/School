function multiBodePlot( data )
%BODEPLOT Plots in a bode plot
% data = 3D matrix
%       - Column 1 = frequencies
%       - Column 2 = Magnitudes
%       - Column 3 = Phases

close all
win(1) = subplot(2,1,1);
    grid on
    title( 'Magnitude Response' );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Amplitude' );
    set( win(1), 'XScale', 'log' );
    set( win(1), 'YScale', 'log' );
    hold on
    
win(2) = subplot(2,1,2);
    grid on
    title( 'Phase Response' );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Phase (Degree)' );
    set( win(2), 'XScale', 'log' );
    hold on

for i = 1:size( data, 3 )
    plot( win(1), data(:,1,i), data(:,2,i), '.-' );
    plot( win(2), data(:,1,i), data(:,3,i), '.-' );
end

end

