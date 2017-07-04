function amp = amplitudeFind( y )
%AMPLITUDEFIND Find's a waves amplitude

maxAmp = max(y(floor(size(y)/2):end));
minAmp = min(y(floor(size(y)/2):end));
amp = (maxAmp - minAmp)/2;

end

