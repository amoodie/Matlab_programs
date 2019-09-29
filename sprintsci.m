function [str] = sprintsci(n, varargin)
%sprintsci Print number in fully formatted scientific notation
%   [str] = sprintsci(n) prints any number n as a LaTeX formatted string in scientific notation for 
%   use in plotting a legend or plot text label. Returns str as a string is
%   n=1, otherwise str is a cell string of formatted strings.
%
%   [str] = sprintsci(n, r) optionally rounds numbers to r digits. Default
%   is to round to 4 digits.

%   adapted from /u/dpb at MATLAB Newsgroup
%   https://www.mathworks.com/matlabcentral/newsreader/view_thread/306693


    % sanity checks
    if ~isempty(varargin)
        if size(varargin) > 3
            error('too many input arguments')
        end
    end
    
    
    % define and process inputs
    defaultRound = 4;
    defaultInterpreter = 'tex';
    
    p = inputParser;
    addRequired(p, 'n');
    addOptional(p, 'r', defaultRound);
    addParameter(p, 'Interpreter', defaultInterpreter);
    parse(p, n, varargin{:});
    
    
    % copy out results
    r = p.Results.r;
    interpreter = p.Results.Interpreter;
    
    
    % process interperter to string
    if strcmp(interpreter, 'tex')
        intstr = '';
    elseif strcmp(interpreter, 'latex')
        intstr = '$';
    else % treat as "none", same as above
        intstr = '';
    end
    

    % process the input(s) to sci print string(s)
    if numel(n) == 1
        expo = floor( log10(n) ); % sci notation exponent
        str = [intstr, num2str(n / 10^expo, r), '\times10^{', num2str(expo), '}', intstr];  % format str
    else
        str = cell(size(n));
        for i = 1:numel(str)
            expo = floor( log10(n(i)) ); % sci notation exponent
            str(i) = { [intstr, num2str(n(i) / 10^expo, r), '\times10^{', num2str(expo), '}', intstr] };  % format str
        end
    end

end
