function [taucr, thetcr] = get_criticalstress(D, varargin)
%get_criticalstress calculation of critical stress of grain mobility
%   [taucr] = get_criticalstress(D) is the critical stress of
%   grain mobility in Pa, calculated by the piecewise function fit by Cao, 2006.
%
%   [taucr] = get_criticalstress(D, con) is the critical stress of grain 
%   mobility calculated using nondimensionalization by the optionally 
%   included structure con, with required variables g (gravitational constant, m/s^2),
%   rho_f (fluid density, kg/m^3), rho_s (particle density, kg/m^3), and nu
%   (fluid kinematic viscosity, m^2/s). When con is not specified, the default
%   environmental constants for quartz in room temperature water are used:
%
%       g = 9.81        m/s^2
%       rho_f = 1000    kg/m^3
%       rho_s = 2650    kg/m^3
%       nu = 1.004e-6   m^2/s
%
%   [taucr, thetcr] = get_criticalstress(D, ...) additionally returns the 
%   non-dimensionalized critical stress of grain mobility thetcr

    if numel(varargin) < 1
        warning('No environmental constants specified (varargin = %d) \nreverting to default values \nsee documentation for details', numel(varargin))
        con.g = 9.81; % gravitational constant
        con.rho_f = 1000; % fluid density, kg/m^3
        con.rho_s = 2650; % particle density, kg/m^3
        con.nu = 1.004 * 1e-6 ; % kinematic viscosity, m^2/s
    elseif numel(varargin) == 1
        con = varargin{1};
    elseif numel(varargin) >= 2
        error('%d inputs after Pow \ntoo many input arguments', numel(varargin))
    end
    con.R = (con.rho_s - con.rho_f) / con.rho_f; % ensure that it exists and is declared by the others? not necessary...
    
    Rep = NaN(size(D));
    thetcr = NaN(size(D));
    for d = 1:length(D)
        Rep(d) = D(d) * sqrt(con.R * con.g * D(d)) / con.nu;
        if Rep(d) <= 6.61;
            thetcr(d) = 0.1414 * Rep(d)^(-0.2306);
        elseif Rep(d) > 6.61 && Rep(d) < 282.84;
            A = (1 + (0.0223 * Rep(d))^(2.8358))^(0.3542);
            B = (3.0946 * Rep(d)^(0.6769));
            thetcr(d) = A / B;
        elseif Rep(d) >= 282.84;
            thetcr(d) = 0.045;
        end
    end 
    taucr = thetcr .* ((con.rho_s - con.rho_f) * con.g) .* D;
end