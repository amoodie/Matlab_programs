function [xpts] = modelEvalPts(xData, varargin)
% modelEvalPts calculates evaluation x points xpts from range of xData
%
%   [xpts] = modelEvalPts(xData) where xData is the input x-data for plotting against the model. If xData is a matrix, each column is treated as a vector and xPts is a 
%
%   [xpts] = modelEvalPts(xData, ...) offers the option to input additional arguments (WORK IN PROGRESS) to specify either
%   'linear' or 'log' or 'smart' spacing of points; default is linear.

    if size(varargin) > 1
        error('too many input arguments')
    elseif size(varargin) == 1
        arg = varargin{:};
        typechk = ischar(arg); % is string
        if ~typechk
            error('input spacing argument is not a string');
        else
            wordchk = ismember(arg, {'linear', 'log', 'smart'});
            if ~wordchk
                error('input spacing argument is not a valid option');
            end
        end
    end
    
    % define and execute parse
    defaultOption = 'linear';
    p = inputParser;
    addParameter(p, 'spacing', defaultOption);
    
    parse(p, varargin{:})
    spacing = p.Results.spacing;
    
    switch spacing
        case 'linear'
            xpts = linspace(min(xData), max(xData), 20);
        case 'log'
            xpts = logspace(min(tab.log10xData), max(tab.log10xData), 20);
        case 'smart'
            %WIP, make default option once working...?
    end
    

end