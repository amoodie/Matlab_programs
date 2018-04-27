function [bulk] = dist2bulk(dist, val)
%dist2bulk per-class in dist weighted avg of val
%   
%   [dist2bulk] = dist2bulk(dist, val) calculates per-class in dist weighted average 
%   of an input value val, returning the bulk sample value. Output is numeric.
% 
%   Input constraints: wip
%   dist is in percent!
    

    if ( isvector(dist) && isscalar(val) ) 
    elseif (all( size(dist) == size(val) ))
    else
        error('dist and val must have same dimensions or a common dimension')
    end
    
    if ~iscell(dist)
        dist = num2cell(dist);
    end
    if ~iscell(val)
        val = num2cell(val);
    end
    
    for i = 1:size(val, 2)
        [bulk(:, i)] = applyFunVerbose(dist, val);
    end
end

function [iBulk] = applyFunVerbose(iDist, iVal)
    applyFun = ( @(d, v) (d ./ 100) .* v );
    [applied] = cellfun(applyFun, iDist, iVal, 'Unif', 0);
    [summed] = cellfun(@nansum, applied);
    iBulk = summed;
    
end


