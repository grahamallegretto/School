function bodePlot( freqs, mags, phases )
%BODEPLOT Plots in a bode plot

figure
subplot(2,1,1);
loglog( freqs, mags, freqs, mags, '.' );
grid on
ylabel( 'Gain (V mm^-^2)' );

subplot(2,1,2);
semilogx( freqs, phases, freqs, phases, '.' );
grid on
xlabel( 'Frequency (Hz)' );
ylabel( 'Phase (Degree)' );

end

