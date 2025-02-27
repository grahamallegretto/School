function data = headerIgnoreCSVRead( fileName )
%headerIgnoreCSVRead Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen( fileName );

% Get to below the header
for i = 1:18
    fgetl(fileID);
end

% Copy everything that is below the header
buffer = fread(fileID, Inf);
fclose(fileID);

% Write it to a file
fileID = fopen('temp.csv','w+');
fwrite(fileID, buffer);
fclose(fileID);

% Reimport it with csv read
data = csvread('temp.csv');

end

