function [mag, phase] = transferFuncFind( time, f, refWave, depWave )
%TRANSFERFUNCFIND Summary of this function goes here
%   Detailed explanation goes here

% Get the average of each wave to speed up fitting
meanRefWave = mean(refWave);
meanDepWave = mean(depWave);

% Two separate functions for each wave to accomodate each wave's offset
sineFuncRef = @(x,xdata,meanVal)...
    x(1).*sin((2*pi*f).*xdata + x(2) )+meanRefWave;
sineFuncDep = @(x,xdata,meanVal)...
    x(1).*sin((2*pi*f).*xdata + x(2) )+meanDepWave;

% Starting points
x0Ref = [(max(refWave)-min(refWave))/2, 0];
x0Dep = [(max(depWave)-min(depWave))/2, 0];

% Perform Fitting
opts = optimset('Display','off');
try
    xRef = lsqcurvefit( sineFuncRef, x0Ref, time, refWave, [], [], opts );
    xDep = lsqcurvefit( sineFuncDep, x0Dep, time, depWave, [], [], opts );
catch
    xRef = lsqcurvefit( sineFuncRef, x0Ref, time', refWave, [], [], opts );
    xDep = lsqcurvefit( sineFuncDep, x0Dep, time', depWave, [], [], opts );
end

% If amplitude is negative, reverse the sign of the amplitude and add pi to
% the phase
if( xRef(1) < 0 )
    xRef(1) = xRef(1)*-1;   
    xRef(2) = xRef(2) + pi;
end
if( xDep(1) < 0 )
    xDep(1) = xDep(1)*-1;   
    xDep(2) = xDep(2) + pi;    
end

% If phase is greater than 2pi, get the remainder
xRef(2) = rem( xRef(2), 2*pi );
xDep(2) = rem( xDep(2), 2*pi );

% Set magnitude and phase
mag = xDep(1);%/xRef(1);        
phase = (xDep(2)-xRef(2))*(180/pi);

% Ensure phase is within +-180 degrees
if phase < -180
    phase = phase + 360;
elseif phase > 180
    phase = phase - 360;
end

end


% subplot(1,2,1);
% plot(time,refWave,'ko',time,sineFuncRef(xRef,time),'b-');
% subplot(1,2,2);
% plot(time,depWave,'ko',time,sineFuncDep(xDep,time),'b-');
