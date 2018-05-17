function [list_struct, list_names] = listing(directory, varargin)
    %listing gets the listing of all *real* items in a directory
    %
    % basically it strips the '.' and '..' folders. 
    % optionally will take 'dirsonly' or 'filesonly' or if any other string
    % or cell array of strings is given, it returns only files with those extensions.
    %
    % returns structure of listing information and filename only listing
    
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
    varargcell = cellfun(@iscell, varargin);
    if any( varargcell )
        keepfiles(rawlist.isdir) = false; % logical of files only
    end
    
    % if any non-cell argument is dirsonly
    if any( cellfun(@(x) strcmp(x, 'dirsonly'), varargin(~varargcell)) )
        keepdirs(~[rawlist.isdir]) = false; % logical of files only
    end
    
    % if any non-cell argument is filesonly
    if any( cellfun(@(x) strcmp(x, 'filesonly'), varargin(~varargcell)) )
        keepfiles([rawlist.isdir]) = false; % logical of files only
    end
    
    % process down to only files or dirs if desired
    typelist = rawlist( and(keepdirs, keepfiles) );
    
    % process the list down to only the types listed in a cell array if given.
    % also check first if the argument supplied begins with a '.xxx' 
    % then it is assumed to be a file type
    for t = length(isaformat)
        
    end
    
    listingnames = arrayfun(@(x) x.name, rawlist, 'Unif', 0);
    listingshoreline = cellfun(@(x) and(contains(x, '.mat'), contains(x, 'shoreline_')), listingnames);
    shorelinefiles = rawlist(listingshoreline);
    listingmeta = cellfun(@(x) and(contains(x, '.mat'), contains(x, 'meta_')), listingnames);
    metafiles = rawlist(listingmeta);
end