function [f, fftOut] = fftSingleSided( data, Fs )
%FFTPLOT Summary of this function goes here
%   Detailed explanation goes here

L = size(data,1);

% Perform FFT
fftComp = fft( data );

% Single and two sided spectrum
P2 = abs( fftComp/L );
fftOut = P2( 1:L/2+1 );
fftOut(2:end-1) = 2*fftOut(2:end-1);

% Define
f = Fs*(0:(L/2))/L;

end

