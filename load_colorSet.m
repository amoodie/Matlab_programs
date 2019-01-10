function [c, varargout] = load_colorSet(colSwitch)
%load_colorSet load color set for data visulatization
%   [c, ...] = load_colorSet(colSwitch) where colSwitch is a string describing
%   the colorset. Options are 'colorful', 'grayscale'. 
%   
%   Output is a matrix c of colors on each row, and variable length list of
%   each color individually.

    switch colSwitch
        case 'colorful'
            col1 = [0.961,0.459,0.494];
            col2 = [0.463,0.729,0.741];
            col3 = [0.988,0.71,0.471];
            col4 = [0.447,0.816,0.388];
        case 'grayscale'
            col1 = [0.2 0.2 0.2];
            col2 = [0.5 0.5 0.5];
            col3 = [0.9 0.9 0.9];
    end
    
    varList = who;
    colLen = length(varList) - 1;
    c = NaN(colLen, 3);
    for i = 1:colLen
        c(i, :) = eval(['col' num2str(i)]);
        varargout{i} = eval(['col' num2str(i)]);
    end

end