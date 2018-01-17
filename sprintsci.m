function [ str ] = sprintsci( n )
%sprintsci Print number in fully formatted scientific notation
%   [str] = sprintsci(n) prints any number n as a LaTeX formatted string in scientific notation for 
%   use in plotting a legend or plot text label.

%   adapted from /u/dpb at MATLAB Newsgroup
%   https://www.mathworks.com/matlabcentral/newsreader/view_thread/306693

    expo = floor( log10(n) );
    str = [num2str(n / 10^expo, 4), '\times10^{', num2str(expo), '}']; 

end
