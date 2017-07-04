function data = headerIgnoreCSVRead( fileName, numIgnore )
%headerIgnoreCSVRead Summary of this function goes here
%   Detailed explanation goes here

% First check if normal csvread works
try 
    data = csvread( fileName );
catch
    fileID = fopen( fileName );

    % For normal files, there are 18 lines of header
    if nargin == 1
        numIgnore = 18;
    end

    % Get to below the header
    for i = 1:numIgnore
        fgetl(fileID);
    end

    % Copy everything that is below the header
    buffer = fread(fileID, Inf);
    fclose(fileID);
    
    delete( fileName );

    % Write it to a file
    fileID = fopen( fileName, 'w+');
    fwrite(fileID, buffer);
    fclose(fileID);

    % Reimport it with csv read and delete temporary file
    data = csvread( fileName );
end

end

