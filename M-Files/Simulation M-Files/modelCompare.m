function modelCompare()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[time, SA, v, VlinOut] = EDLSimulation2('sine','SAOffset',50,'SAAmp',5, ...
    'toPlot', false, 'closeAll', false, 'numCycles', 3 );
subplot(4,1,1);
plot( time, v, time, VlinOut );

[time, SA, v, VlinOut] = EDLSimulation2('sine','SAOffset',50,'SAAmp',10,...
    'toPlot', false, 'closeAll', false, 'numCycles', 3 );
subplot(4,1,2);
plot( time, v, time, VlinOut );

[time, SA, v, VlinOut] = EDLSimulation2('sine','SAOffset',50,'SAAmp',20,...
    'toPlot', false, 'closeAll', false, 'numCycles', 3 );
subplot(4,1,3);
plot( time, v, time, VlinOut );

[time, SA, v, VlinOut] = EDLSimulation2('sine','SAOffset',50,'SAAmp',40,...
    'toPlot', false, 'closeAll', false, 'numCycles', 3 );
subplot(4,1,4);
plot( time, v, time, VlinOut );
xlabel('Time (s)');

end

