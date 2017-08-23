function SA = surfaceAreaPlot( filename )
%SURFACEAREAPLOT Summary of this function goes here
%   Detailed explanation goes here

vid = VideoReader(filename);
imshow( readFrame( vid ) );

% Click for 5mm on grid
[x,y] = ginput(2);
pixNum = sqrt( (x(1) - x(2))^2 + (y(1) - y(2))^2 );
mmPerPixel = 10/pixNum;

% Zoom
p = ginput(2);

% Get the x and y corner coordinates as integers
sp(1) = min(floor(p(1)), floor(p(2))); %xmin
sp(2) = min(floor(p(3)), floor(p(4))); %ymin
sp(3) = max(ceil(p(1)), ceil(p(2)));   %xmax
sp(4) = max(ceil(p(3)), ceil(p(4)));   %ymax

i = 1;
modVal=1;
while i < 120
    frame = readFrame( vid );
    frame = frame(sp(2):sp(4), sp(1): sp(3),:);
    
    eqHist = histeq(frame(:,:,1));
    imshow( frame );
    
    if mod(i,modVal) == 0
        [x,y] = ginput(2);
        SA(i/modVal) = abs(x(1) - x(2)) * mmPerPixel;
    end
    i = i + 1;
end

