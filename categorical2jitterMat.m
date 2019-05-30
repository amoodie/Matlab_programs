function [dataMat, jitterMat, groupMat] = categorical2jitterMat(data, categRaw, varargin)
%categorical2jitterMat reshapes data for parallel boxplot-jitterplot
%   [dataMat, jitterMat, groupMat] = categorical2jitterMat(data, categRaw, ...)
%   where data is a nx1 matrix which contains the values to be characterized
%   in the boxplot, categRaw is a nx1 matrix (or cell array) which the 
%   boxplot will be grouped by. Optionally supply a cell array of categories
%   not included in categRaw that should be included in the grouping anyway.
%
%   Returns dataMat which is a matrix containing one column of values 
%   for each category in the data. jitterMat is the same shape, but has the
%   x-coordinates to plot the jitter. groupMat is a matrix indicating the group.
%
%   to plot, use:
%
%   figure(); hold on
%   plot(dataMat, jitterMat, 'ko')
%   boxplot(dataMat)
%

    % varargin options listings
    options = struct('positions',0 ,'missing_groups',0);

    %# read the acceptable names
    optionNames = fieldnames(options);

    %# count arguments
    nArgs = length(varargin);
    if round(nArgs/2)~=nArgs/2
       error('varargin must be given as propertyName/propertyValue pairs')
    end

    for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
       inpName = lower(pair{1}); %# make case insensitive

       if any(strcmp(inpName, optionNames))
          % overwrite options given
          options.(inpName) = pair{2};
       else
          error('%s is not a recognized parameter name', inpName)
       end
    end


    % check if the category vector is a cell array and attempt conversion.
    if iscell(categRaw)
        if isnumeric(categRaw{1})
            categRaw = cellfun(@(x) x, categRaw);
        else
            warning('categRaw is a cell array of type non-numeric. Leaving it alone and attempting to proceed...')
        end
    end

    % make the raw categories into a list and find the groups.
    categList = categorical(categRaw);
    groupList = categories(categList);
    
    % get the number of items in each group, for matrix dimensions
    nPerGroup = splitapply(@numel, data, findgroups(categRaw));
    
    % if varargin, splice in the extra categories if given
    if iscell(options.missing_groups) % == 0)
        groupList = [groupList; options.missing_groups'];
        [groupList, sortIdx] = sort(groupList);
        nPerGroup = [nPerGroup; zeros((size(groupList, 1) - size(nPerGroup,1)), 1)];
        nPerGroup = nPerGroup(sortIdx);
    end
    
    % handle the positions argument
    if (options.positions == 0)
        positions = 1:length(groupList);
    else
        positions = options.positions;
    end
    
    % validate that length of groups matches positions
    if ~(length(groupList) == length(positions))
        error('number of groups and positions does not match')
    end
    
    % initialize the matrix at the full size
    dataMat = NaN(max(nPerGroup), length(groupList));
    
    % loop through list, adding data into the matrix
    for i = 1:length(groupList)
        dataMat(1:nPerGroup(i), i) = data(categRaw == str2num(cell2mat(groupList(i))));
    end
   
    
    
    % if older than version x else
    % note this is untested for older versions...
    if verLessThan('matlab', '9.4.0')
         % execute code for R2018a or earlier
         jitter = abs( randn(size(dataMat))/(length(groupList)*10) );
         offset = 2 / length(groupList);
         jitterMat = repmat(postitions, size(dataMat, 1), 1) + offset + jitter;
    else
        % execute code for R2018b or later
         jitter = ( randn(size(dataMat))/(length(groupList)*10) );
         offset = 0;
         jitterMat = repmat(positions, size(dataMat, 1), 1) + offset + jitter;
    end
    
    
    % group mat is the group each belongs to
    try
        groupMat = repmat(cellfun(@str2num, groupList)', size(dataMat, 1), 1);
    catch
        warning('non-numeric categories, groupMat empty')
        groupMat = NaN(size(jitterMat));
    end
    
end
