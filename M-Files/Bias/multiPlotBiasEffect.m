function data = multiPlotBiasEffect( timeScale )
%MULTIPLOTBIASEFFECT Summary of this function goes here
%   Detailed explanation goes here

filenames = dir('*.csv');

tempData = headerIgnoreCSVRead( filenames(1).name );
data = zeros( floor(size(tempData,1)/(timeScale*1000)), 3, size(filenames,1) );

for i = 1:size(filenames,1)
    data(:,:,i) = biasEffect( filenames(i).name, timeScale );
    filenames(i).name
end

plotMultiBias( data, 1);

