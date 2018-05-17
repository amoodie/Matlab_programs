function [list] = listing(directory, varargin)
    %listing gets the listing of all *real* items in a directory
    %
    % basically it strips the '.' and '..' folders. 
    % optionally will take 'dirsonly' or 'filesonly' or if any other string
    % or cell array of strings is given, it returns only files with those extensions.
    %
    
    if ~or(ischar(directory), isstring(directory))
        error('directory specification must be char or string')
    end
    % add a check for the directory to exist? Or will matlab's dir handle it?
    
    vararglen = length(varargin);
    
    % get the listing of all items in the dir and remove the known unwanted
    rawlist = dir(directory); % all items in directory
    rawlist(ismember( {rawlist.name}, {'.', '..'})) = [];  % dont want . or ..
    rawlistlen = size(rawlist, 1);
    
    % initially assume true for both to keep everything
    keepfiles = true(rawlistlen, 1);
    keepdirs = true(rawlistlen, 1);
    
    % if a cell array is given, filesonly is assumed
    % check cell array for all to be .*** file types
    if any(cellfun(@iscell, varargin))
        keepfiles ;
        
    
    end
    
    
    filesBool = ~[rawlist.isdir]; % logical of files only
    rawlist = rawlist(filesBool);
    listingnames = arrayfun(@(x) x.name, rawlist, 'Unif', 0);
    listingshoreline = cellfun(@(x) and(contains(x, '.mat'), contains(x, 'shoreline_')), listingnames);
    shorelinefiles = rawlist(listingshoreline);
    listingmeta = cellfun(@(x) and(contains(x, '.mat'), contains(x, 'meta_')), listingnames);
    metafiles = rawlist(listingmeta);
end