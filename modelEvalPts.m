function [xpts] = modelEvalPts(xData, varargin)
% modelEvalPts calculates evaluation x points xpts from range of xData
% Andrew J. Moodie 2018
%
%   [xpts] = modelEvalPts(xData) where xData is the input x-data for
%   plotting against the model. If xData is a matrix, each column is
%   treated as a vector and xPts is a
%
%   [xpts] = modelEvalPts(xData, ...) offers the option to input additional
%   arguments to specify both/either the spacing method and/or the number
%   of points. Spacing options are 'linear' or 'log' spacing of
%   points; default is linear. Number is any integer > 0.

    %% parse out inputs
    % check for inputs and get index of input type
    if length(varargin) > 2
        error('too many input arguments')
    elseif length(varargin) <= 2 && ~isempty(varargin)
        charchk = cellfun(@ischar, varargin); % is string
        numchk = cellfun(@isnumeric, varargin);
        if ~(sum(charchk) == 1 || sum(numchk) == 1) % if more than one string or num
            error('if two optional inputs, one must be string and other must be numeric');
        else
            spacingIdx = find(charchk);
            numIdx = find(numchk);  
        end
    else
        spacingIdx = [];
        numIdx = [];
%         error('????')
    end
    
    %% apply varargin or defaults
    if isempty(spacingIdx)
        spacing = 'linear'; % default
    else
        spacing = varargin{spacingIdx};
    end
    if isempty(numIdx)
        num = 100; % default option
    else
        num = varargin{numIdx};
    end
    
    %% final sanitize
    if ~( ismember(spacing, {'linear', 'log', 'smart'}) ) % sanitize spacing
        error('input spacing argument is not a valid option');
    end
    if ~( mod(num,1) == 0 ) % sanitize num
        error('input number is not an integer')
    end

    % determine computation for smart spacing choice??
    
    %% compute    
    switch spacing
        case 'linear'
            xpts = linspace(min(xData), max(xData), num);
        case 'log'
            xpts = logspace(min(log10(xData)), max(log10(xData)), num);
    end
    

end