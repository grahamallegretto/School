function [pks, troughs] = findPeaks( data, vDeadband )
%FINDPEAK Summary of this function goes here
%   Detailed explanation goes here

% Find peaks and valleys of the displacement curve
[pks,pkLocs] = findpeaks(data);
[troughs,troughLocs] = findpeaks(data.*-1);
troughs = -1*troughs;

% Get rid of troughs that are greater than average
troughLocs = troughLocs( troughs < -1*vDeadband );
troughs = troughs( troughs < -1*vDeadband );

% Get rid of Peaks that are less than average
pkLocs = pkLocs( pks > vDeadband );
pks = pks( pks > vDeadband );

% Merge peaks and troughs
maximin = [[pkLocs; troughLocs] [pks; troughs]];
[~, order] = sort(maximin(:,1));
maximin = maximin(order,:);

% Ensure that there is a trough between every peak and a peak between
% every trough.
i = 1;
while i < size(maximin,1)
    % Is it a trough?
    if maximin(i,2) < 0
        i = i + 1;
        % Make sure it's the lowest trough
        if maximin(i,2) < maximin(i-1,2)
            maximin(i-1,2) = 0;
        else
            % Get rid of any troughs that are after the heighest one and
            % before the next peak
            while (maximin(i,2) < 0) && (i < size(maximin,1))
                maximin(i,2) = 0;
                i = i + 1;
            end
        end
    else
        i = i + 1;
        % Make sure it's the highest peak
        if maximin(i,2) > maximin(i-1,2)
            maximin(i-1,2) = 0;
        else       
            % Get rid of any peaks that are after the lowest one and
            % before the next trough
            while (maximin(i,2) > 0) && (i < size(maximin,1))
                maximin(i,2) = 0;
                i = i + 1;
            end
        end
    end
end
maximin = maximin( abs(maximin(:,2)) > 0, : ); 

% Determine the peaks for the period calculation
pks = maximin(maximin(:,2)>0,:);
troughs = maximin(maximin(:,2)<0,:);

end

