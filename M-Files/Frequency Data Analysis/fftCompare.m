function fftCompare( filename )
%FFTCOMPARE Summary of this function goes here
%   Detailed explanation goes here

H2OData = headerIgnoreCSVRead( [filename, '_H2O.csv'], 4 );
noH2OData = headerIgnoreCSVRead( [filename, '_noH2O.csv'], 4 );

[ f, H2OFFT ] = fftSingleSided( H2OData(:,4), 2500 );
[ ~, noH2OFFT ] = fftSingleSided( noH2OData(:,4), 2500 );
magnifyFFT = H2OFFT./noH2OFFT;

subplot(2,1,1);
plot( f, H2OFFT, f, noH2OFFT );
legend( 'Background', 'H_2O' );

subplot(2,1,2);
plot( f, magnifyFFT );

end

