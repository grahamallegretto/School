function dataCruncher( file, load )
%DATACRUNCHER Summary of this function goes here
%   Detailed explanation goes here

% Read in data
data = csvread( file );

% Find peaks and valleys of the displacement curve
[pks,pkLocs] = findpeaks(data(:,6),4);
[troughs,troughLocs] = findpeaks(data(:,6)*-1);
troughs = -1*troughs;

% Get rid of troughs that are greater than -0.02
troughLocs = troughLocs( troughs < -0.02 );
troughs = troughs( troughs < -0.02 );

% Get rid of Peaks that are less than 0.02
pkLocs = pkLocs( pks > 0.02 );
pks = pks( pks > 0.02 );

plot(1:size(data,1),data(:,6),pkLocs,pks,'o',troughLocs,troughs,'o');

if nargin > 1 
    power = data(:,6).^2 / (load * 1e6);
    plot(power);
end
    
end

