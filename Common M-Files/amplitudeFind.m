function amp = amplitudeFind( y )
%AMPLITUDEFIND Find's a waves amplitude

maxAmp = max(y);
minAmp = min(y);
amp = (maxAmp - minAmp)/2;

end

