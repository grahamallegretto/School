function bodePlot2( freqs, mags, phases, freqs2, mags2, phases2 )
%BODEPLOT Plots in a bode plot

figure
subplot(2,1,1);
loglog( freqs, mags, freqs, mags, '.', ...
    freqs2, mags2, freqs2, mags2, '.' );
grid minor
ylabel( 'Gain (V mm^-^2)' );


subplot(2,1,2);
semilogx( freqs, phases, freqs, phases, '.', ...
    freqs2, phases2, freqs2, phases2, '.' );
axis( [0.1 100 -inf inf] );   
grid minor
xlabel( 'Frequency (Hz)' );
ylabel( 'Phase (Degree)' );

end

