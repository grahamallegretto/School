function [ fitLine ] = vBiasMeasure( data, discardZero )
%VBIASMEASURE Summary of this function goes here
%   Detailed explanation goes here

deriv = diff( data(:,2) );

rawNegLine = data( deriv <= 0,:);
rawNegLineShortened = rawNegLine(discardZero+1:end-discardZero,:);
rawPosLine = data( deriv > 0, :);
rawPosLineShortened = rawPosLine(1+discardZero:end-discardZero,:);

negP = polyfit( rawNegLineShortened(:,1), rawNegLineShortened(:,2), 1 );
posP = polyfit( rawPosLineShortened(:,1), rawPosLineShortened(:,2), 1 );

xZero = (negP(2)-posP(2))/(posP(1)-negP(1));

fitLine(:,1) = [ data(1,1); xZero; data(end,1)];
fitLine(:,2) = [ data(1,1)*negP(1) + negP(2);...
                 xZero*negP(1) + negP(2);...
                 data(end,1)*posP(1) + posP(2)];
             
end

