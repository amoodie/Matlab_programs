function [formatStr] = formatRegression(betaMat, predCell)
%formatRegression formats a linearized multivariate regression matrix to a power law regression string
%   [formatStr] = formatRegression(betaMat, predCell) where betaMat is the 
%   matrix of estimates returned from the regression and predCell is a 1xn 
%   cell array of the variables in the regression, as they should be printed
%   in the string.
%
%   NOTE: this is intended for translating the beta values assuming they 
%   come from data that was linearized (e.g., log(x)) before regression.


    % compare sizes, must match
    if max(size(betaMat))-1  ~=  max(size(predCell))
        error('inputs must have same dimensions')
    end
    
    % formatting vars
    
    
    % format by looping through and splicing in necessary chars to make a long string to format with
    fS = [];
    fS = [fS 'E_s = '];
    fS = [fS smart(betaMat(1)) ' '];
    for i = 1:max(size(predCell))
        fS = [fS '(' predCell{i} ')^{' smart(betaMat(i+1)) '}'];
    end
    formatStr = fS;

end

function [str] = smart(x)
    if abs( floor( log10(abs(x)) ) ) > 2
        [str] = sprintsci(x, 2);
    else
        str = num2str(x, 2);
    end
end