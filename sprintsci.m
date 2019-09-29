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

    if ~isempty(varargin)
        if size(varargin) > 1
            error('too many input arguments')
        end
        r = varargin{1};
    else
        r = 4;
    end

    if numel(n) == 1
        expo = floor( log10(n) ); % sci notation exponent
        str = [num2str(n / 10^expo, r), '\times10^{', num2str(expo), '}'];  % format str
    else
        str = cell(size(n));
        for i = 1:numel(str)
            expo = floor( log10(n(i)) ); % sci notation exponent
            str(i) = { [num2str(n(i) / 10^expo, r), '\times10^{', num2str(expo), '}'] };  % format str
        end
    end

end
