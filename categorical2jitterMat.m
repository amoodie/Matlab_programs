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
%   figure()
%   plot(dataMat, jitterMat, 'ko')
%   boxplot(dataMat)
%


    % check if the category vector is a cell array and attempt conversion.
    if iscell(categRaw)
        if isnumeric(categRaw{1})
            categRaw = cellfun(@(x) x, categRaw);
        else
            warning('categRaw is a cell array of type non-numeric. Leaving it alone and attempting to proceed...', 
        end
    end

    % make the raw categories into a list and find the groups.
    categList = categorical(categRaw);
    groupList = categories(categList);
    
    % get the number of items in each group, for matrix dimensions
    nPerGroup = splitapply(@numel, data, findgroups(categRaw));
    
    % if varargin, splice in the extra categories
    if ~isempty(varargin)
        groupList = [groupList; varargin{:}'];
        [groupList, sortIdx] = sort(groupList);
        nPerGroup = [nPerGroup; zeros((size(groupList, 1) - size(nPerGroup,1)), 1)];
        nPerGroup = nPerGroup(sortIdx);
    end
    
    % initialize the matrix at the full size
    dataMat = NaN(max(nPerGroup), length(groupList));
    
    % loop through list, adding data into the matrix
    for i = 1:length(groupList)
        dataMat(1:nPerGroup(i), i) = data(categRaw == str2num(cell2mat(groupList(i))));
    end
    
    % the jitter matrix, offset from the category axes
    jitterMat = repmat(1:length(groupList), size(dataMat, 1), 1) + randn(size(dataMat))/(length(groupList)*10);
    
    % group mat is the group each belongs to
    try
        groupMat = repmat(cellfun(@str2num, groupList)', size(dataMat, 1), 1);
    catch
        warning('non-numeric categories, groupMat empty')
        groupMat = NaN(size(jitterMat));
    end
    
end