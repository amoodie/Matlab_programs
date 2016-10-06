function [ws, wa] = get_DSV(D, CSF, Pow, varargin)
%get_DSV calculation of Dietrich settling velocity
%   ws = get_DSV(D, CSF, Pow) is the Dietrich settling velocity 
%   (Dietrich, 1982) in m/s for each of the elements of D, where D is in meters.
%   CSF is the Corey shape factor and Pow is the Power's index.
%
%   ws = get_DSV(D, CSF, Pow, con) uses the optionally included structure con, 
%   with required variables g (gravitational constant, m/s^2), rho_f (fluid density, kg/m^3),
%   rho_s (particle density, kg/m^3), and nu (fluid kinematic viscosity, m^2/s).
%   When con is not specified, the default environmental constants for
%   quartz in room temperature water are used:
%
%       g = 9.81        m/s^2
%       rho_f = 1000    kg/m^3
%       rho_s = 2650    kg/m^3
%       nu = 1.004e-6   m^2/s
%
%   [ws, wa] = get_DSV(D, CSF, Pow, ...) additionally returns the non-dimensionalized
%   Dietrich settling velocity wa

    % check if constants supplied
    if numel(varargin) < 1 % if not supplied, revert to default and warn user
        warning('No environmental constants specified (varargin = %d) \nreverting to default values \nsee documentation for details', numel(varargin))
        con.g = 9.81; % gravitational constant
        con.rho_f = 1000; % fluid density, kg/m^3
        con.rho_s = 2650; % particle density, kg/m^3
        con.nu = 1.004 * 1e-6 ; % kinematic viscosity, m^2/s
    elseif numel(varargin) == 1 % if supplied, assign to structure 'con'
        con = varargin{1};
    elseif numel(varargin) >= 2 % too many arguments, throw error
        error('%d inputs after Pow \ntoo many input arguments', numel(varargin))
    end

    % validate data range
    if CSF <= 0.15;
        error('solution invalid for CSF <= 0.15');
    end

    % preallocate for number of grain sizes input
    wa = NaN(size(D));
    ws = NaN(size(D));
    
    for d = 1:length(D(:)) % for each grain size
        Da = get_Da(D(d), con); % non-dimensionalize with constants
        if Da <= 0.05; % use Stokes for Da <= 0.05, from Dietrich, 1982 paper
            wa(d) = 1.71e-4 * (Da^2); 
        elseif Da > 0.05 && Da <= 5e9; % use Dietrich if within valid range
            wa(d) = DSV_fit(Da, CSF, Pow);
        elseif Da > 5e9; % return warning and NaN for invalid range
            warning('%f \nsolution invalid for Da > 5e9 \nreturning NaN', Da)
            wa(d) = NaN; % no consideration to turbulence so invalid above this size
        end
        ws(d) = get_ws(wa(d), con); % dimensionalize
    end
    
end

function [Da] = get_Da(D, con)
    % non-dimensionalize the grain size
    Da = ((con.rho_s - con.rho_f) * con.g * (D ^ 3)) / (con.rho_f * (con.nu ^ 2));
end

function [ws] = get_ws(wa, con)
    % dimensionalize the settling velocity
    ws = ((wa * (con.rho_s - con.rho_f) * con.g * con.nu) / con.rho_f)^(1/3);
end

function wa = DSV_fit(Da, CSF, Pow)
    % calculate settling velocity by Dietrich, 1982
    R_1 = (-3.76715) + (1.92944 * log10(Da)) - (0.09815 * (log10(Da)^(2.0))) - (0.00575 * (log10(Da)^(3.0))) + (0.00056 * (log10(Da)^(4.0)));
    R_2 = (log10(1 - ((1 - CSF) / 0.85))) - (((1 - CSF)^(2.3)) * tanh(log10(Da) - 4.6)) + (0.3 * (0.5 - CSF) * ((1 - CSF)^(2.0)) * (log10(Da) - 4.6));
    R_3 = (0.65 - ((CSF / 2.83) * tanh(log10(Da) - 4.6)))^(1 + (3.5 - Pow)/2.5);
    wa = R_3 * (10 ^ (R_1 + R_2));
end
