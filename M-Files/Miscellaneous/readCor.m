function data = readCor( file_name )
%READCOR Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen(file_name);

% Get to below the header
for i = 1:1000000
    tline = fgetl(fileID);
    if(strcmp(tline,'End Comments') == 1)
        break;
    end
end

% Copy everything that is below the header
buffer = fread(fileID, Inf);
fclose(fileID);

% Write it to a file
fileID = fopen('temp.txt','w+');
fwrite(fileID, buffer);
fclose(fileID);

% Reimport it with csv read
data = importdata('temp.txt');
delete('temp.txt');

end

