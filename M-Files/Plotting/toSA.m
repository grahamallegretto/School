function toSA( SAData, SAOffset, SAAmp )
%TOSA Summary of this function goes here
%   Detailed explanation goes here

SAData = SAData(:,[2 4 6]);

% Since the data we're using from the BOSE machine is in displacement we
% need to convert it to surface area.
SAData(:,2) = SAData(:,2) -  mean(SAData(:,2));

AGain = SAAmp / max( SAData(:,2) );
SAData(:,2) = (-1.*AGain.*SAData(:,2)) + (SAOffset - mean(SAData(:,2)));

[AX,H1,H2] = plotyy( SAData(:,1), SAData(:,2), SAData(:,1), SAData(:,3) );
set(get(AX(1),'Ylabel'),'String','Surface Area (mm^2)');

set(get(AX(2),'Ylabel'),'String','Voltage (V)');
xlabel( 'Time (s)' );

end

