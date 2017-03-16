function subPlotModified( x, y1, y2, y3, title, xAxisName, y1AxisName, ...
    y2AxisName, y2Legend, y3Legend )
%SUBPLOTMODIFIED Summary of this function goes here
%   Detailed explanation goes here
subplot(2,1,1);
plot(x,y1);
title(title);
xlabel(xAxisName);
ylabel(y1AxisName);

subplot(2,1,2);
plot(x,y2,x,y3);
xlabel(xAxisName);
ylabel(y2AxisName);
legend( y2Legend, y3Legend );

end

