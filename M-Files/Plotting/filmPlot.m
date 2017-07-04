function filmPlot( filename, stepLeng, windowLength, timeLength )
%FILMPLOT Summary of this function goes here
%   Detailed explanation goes here

% Read in data
data = headerIgnoreCSVRead( filename );
Ts = data(2,2) - data(1,2);
windowStep = windowLength/Ts;
timeStep = timeLength/Ts;
loops = timeLength*1000/windowLength;

% Find Max and min values for plotting
maxV = max( data(:,6) );
minV = min( data(:,6) );
dV = (maxV-minV)*0.1;
maxV = maxV + dV;
minV = minV - dV;

% For the video
j = 0;
v = VideoWriter('dataPlot.avi');
open(v);

% Plot the first of the window
for i = 1:stepLeng:windowStep
    plot( data( 1:i, 2 ), data( 1:i, 6 ) );
    axis( [0 windowLength minV maxV] );
    xlabel( 'Time (s)' );
    ylabel( 'Voltage (V)' );
    pause(0.001*stepLeng);
    frame = getframe(gcf);
    writeVideo(v,frame);
end

% Now plot till the end specified in a paramenter
for i = stepLeng:stepLeng:timeStep-windowStep
    plot( data( 1:i+windowStep, 2 ), data( 1:i+windowStep, 6 ) );
    axis( [data(i,2) data(i+windowStep,2) minV maxV] );
    xlabel( 'Time (s)' );
    ylabel( 'Voltage (V)' );
    pause(0.001*stepLeng);
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);
