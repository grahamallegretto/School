function data = reverseplot( imageName, xRange, yRange )
%REVERSEPLOT Takes an input jpeg of a graph and returns data to make it
%   Looks for the jpeg with the name it has and the xRange and yRange and
%   returns the data that can be used to build the same plot
close all;
warning('off','all');

% Read in graph and convert it to color
color = imread(imageName);
imageSize = size(color);

% Declarations 
dataPoints = zeros(1,imageSize(2));

% Show original image and have user select colors for different plot points
imshow(color);
title('Select Color of plot');
[xInput,yInput] = ginput(1);
close;

% Figure for performing image operations on images
figHandle   = figure('Visible','off','Position',[150,250,1100,500]);
hOpen       = uicontrol('Style','pushbutton','String','Open',...
                        'Position',[980,400,70,25],'Callback',...
                        @openbutton_Callback);
hClose      = uicontrol('Style','pushbutton','String','Close',...
                        'Position',[980,360,70,25],'Callback',...
                        @closebutton_Callback);
hDilate     = uicontrol('Style','pushbutton','String','Dilate',...
                        'Position',[980,320,70,25],'Callback',...
                        @dilatebutton_Callback);
hErode      = uicontrol('Style','pushbutton','String','Erode',...
                        'Position',[980,280,70,25],'Callback',...
                        @erodebutton_Callback);
hDone       = uicontrol('Style','pushbutton','String','Done',...
                        'Position',[980,50,70,25],'Callback',...
                        @donebutton_Callback); 
hSlider     = uicontrol('Style','slider','Min',0,'Max',100,...
                        'Value',50,'Position',[950,240,130,25],...
                        'SliderStep',[0.01 0.1],'Callback',...
                        @thresholdSlider_Callback); 
                    
%Perform initial thresholding
colorValue = color(floor(yInput),floor(xInput),:);

redRGB = bitand( color(:,:,1) < (colorValue(1,1,1) + 50),...
    color(:,:,1) > (colorValue(1,1,1) - 50) );
greenRGB = bitand( color(:,:,2) < (colorValue(1,1,2) + 50),...
    color(:,:,2) > (colorValue(1,1,2) - 50) );
blueRGB = bitand( color(:,:,3) < (colorValue(1,1,3) + 50),...
    color(:,:,3) > (colorValue(1,1,3) - 50) );
dataLine = bitand( greenRGB, bitand( blueRGB, redRGB ) );

colorAxes = subplot('Position',[0.05 0.05 0.35 0.9]);
imshow(color);
dataAxes = subplot('Position',[0.48 0.05 0.35 0.9]);
imshow(~dataLine);

updateDataPoints();

uiwait();

%% Figure functions
    function updateDataPoints()
        axes(colorAxes);
        imshow(color);
        hold on;
        
        % Create the data points based on the top and bottom points of the 
        % line
        [rowIdx,colIdx] = find(dataLine);
        maxPoints = accumarray(colIdx,rowIdx,[],@max);
        minPoints = accumarray(colIdx,rowIdx,[],@min);
        dataPoints = floor((maxPoints+minPoints)/2);
        
        plot(dataPoints);
    
        hold off;
        axes(dataAxes);
    end
%%
% Push button callback functions
    function openbutton_Callback(source,eventdata)
        dataLine = bwmorph(dataLine,'open');
        imshow(~dataLine);
        updateDataPoints()
    end

    function closebutton_Callback(source,eventdata)
        dataLine = bwmorph(dataLine,'close');
        imshow(~dataLine);
        updateDataPoints()
    end

    function dilatebutton_Callback(source,eventdata)
        dataLine = bwmorph(dataLine,'dilate');
        imshow(~dataLine);
        updateDataPoints()
    end

    function erodebutton_Callback(source,eventdata)
        dataLine = bwmorph(dataLine,'erode');
        imshow(~dataLine);
        updateDataPoints()
    end

    function donebutton_Callback(source,eventdata)
        uiresume()
        warning('on','all');
        fullXRange = linspace(xRange(1),xRange(2),imageSize(2));
      
        notZeroCol = logical(max(dataLine,[],1));
        leftNonZero = find(notZeroCol,1,'first');
        rightNonZero = find(notZeroCol,1,'last');

        data(:,1) = fullXRange(leftNonZero:rightNonZero);
        data(:,2) = yRange(1) + ((imageSize(1)-dataPoints(leftNonZero:rightNonZero))./imageSize(1)).*(yRange(2)-yRange(1));
    end

    function thresholdSlider_Callback(source,eventdata);
        thresholdValue = get(source,'Value');
        redRGB = bitand( color(:,:,1) < (colorValue(1,1,1) + thresholdValue),...
            color(:,:,1) > (colorValue(1,1,1) - thresholdValue) );
        greenRGB = bitand( color(:,:,2) < (colorValue(1,1,2) + thresholdValue),...
            color(:,:,2) > (colorValue(1,1,2) - thresholdValue) );
        blueRGB = bitand( color(:,:,3) < (colorValue(1,1,3) + thresholdValue),...
            color(:,:,3) > (colorValue(1,1,3) - thresholdValue) );
        dataLine = bitand( greenRGB, bitand( blueRGB, redRGB ) );
        imshow(~dataLine);
        updateDataPoints()
    end
    close all;
end


