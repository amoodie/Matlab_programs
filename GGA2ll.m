function [point, latmean, lonmean, zmean] = GGA2ll(filepath)
    %GGA2ll reads a NMEA GGA string dump in filepath and processes to a single lat, lon, z point
    %
    % [point] = GPGGA2ll(filepath) takes a single file with a NMEA GGA string
    % dump and averages all position information to a single location, 
    % returned as a 1x3 matrix point with latitude, longitude, elevation.
    %
    % [point, latmean, lonmean, zmean] = GPGGA2ll(filepath) will optionally
    % return the values as separate scalars. 
    %
    % NOTE: at present, the dump files must be clean, that is, they may have
    % a single header line, but following must be all valid format GGA strings.
    % an error will likely result if a file contains a corrupted line.
    %
    
    % read data into a single table
    df = readtable(filepath, 'Delimiter', ',', 'HeaderLines', 1, ...
         'Format', repmat('%s ', 1, 15), 'ReadVariableNames', false);
    
    % load data into a single table
    latdecmin = df.Var3; % decimal minutes lat raw
    lathemi = df.Var4; % hemisphere of lat
    londecmin = df.Var5; % decimal minutes lon raw
    lonhemi = df.Var6; % hemisphere of lon
    zraw = df.Var10; % elevation raw

    % clean empty values from the table
    % (an attempt at providing some resiliency to bad datafile)
    latdecmin(cellfun(@isempty, latdecmin)) = [];
    londecmin(cellfun(@isempty, londecmin)) = [];
    zraw(cellfun(@isempty, zraw)) = [];
    
    % find the index of the period in the lat lon strings
    latperidx = strfind(latdecmin{1}, '.');
    lonperidx = strfind(londecmin{1}, '.');
    
    % where to start the decimal minutes 
    latstidx = latperidx - 3;
    lonstidx = lonperidx - 3;
    
    % strip out the degrees numbers
    latdeg = cellfun(@(x) str2num( x(1:latstidx) ), latdecmin);
    londeg = cellfun(@(x) str2num( x(1:lonstidx) ), londecmin);
    
    % convert to negative if hemisphere dictates
    if strcmp(lathemi{1}, 'S')
        latdeg = -latdeg;
    end
    if strcmp(lonhemi{1}, 'W')
        londeg = -londeg;
    end
    
    % convert the minutes portion to a number
    latdecraw = cellfun(@(x) str2num( x(latstidx+1:end) ), latdecmin);
    londecraw = cellfun(@(x) str2num( x(lonstidx+1:end) ), londecmin);
    
    % convert the minutes fraction to degrees fraction
    latdec = latdecraw / 60;
    londec = londecraw / 60;
    
    % sum the degress and minutes fraction
    latdecdeg = latdeg + latdec;
    londecdeg = londeg + londec;
    
    % convert elevation to a number
    znumeric = cellfun(@(x) str2num(x), zraw);
    
    % average all the data in file
    latmean = mean(latdecdeg);
    lonmean = mean(londecdeg);
    zmean = mean(znumeric);
    
    % cat to single matrix
    point = [latmean, lonmean, zmean];
    
end