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
idxPk = 1;
idxTr = 1;
clear pks; clear troughs;
while i < size(maximin,1)
    % Is it a Peak?
    if maximin(i,2) > 0
        % Get all the peaks corresponding to a maximum
        j = i;
        while (maximin(j,2) > 0) && (j < size(maximin,1))
            j = j+1;
        end
        [pks(idxPk,2), idx] = max( maximin(i:j-1,2) );
        pks(idxPk,1) = maximin(i+idx-1,1);
        idxPk = idxPk + 1;
        i = j;
    else
        % Get all the troughs corresponding to a maximum
        j = i;
        while (maximin(j,2) < 0) && (j < size(maximin,1))
            j = j+1;
        end
        [troughs(idxTr,2), idx] = min( maximin(i:j-1,2) );
        troughs(idxTr,1) = maximin(i+idx-1,1);
        idxTr = idxTr + 1;
        i = j;
    end
end

% Plot for inspection
% plot(1:size(data,1),data(:,1),pks(:,1),pks(:,2),'r.',troughs(:,1),troughs(:,2),'b.')

end

