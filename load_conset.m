function [con] = load_conset(conset)
%load_cons load a set of environmental constants 
%   con = get_DSV(conset) loads a set of environmental constants defined by
%   the environment set by the defining string conset. Environmental constants
%   at a minimum are g (gravitational acceleration), rho_f (fluid density),
%   rho_s (sediment density), and nu (fluid kinematic viscosity).
%
%   Acceptable values for conset are:
%       - quartz-water
%       - quartz-air
%       - gypsum-air
%
%   Use type load_cons to view the constants set by each conset.

    switch conset
        case 'quartz-water'
            con.g = 9.81; % gravitational constant
            con.rho_f = 1000; % fluid density, kg/m^3
            con.rho_s = 2650; % particle density, kg/m^3
            con.nu = 1.004 * 1e-6; % fluid kinematic viscosity, m^2/s
        case 'quartz-air'
            con.g = 9.81; % gravitational constant
            con.rho_f = 1.225; % fluid density, kg/m^3
            con.rho_s = 2650; % particle density, kg/m^3
            con.nu = 1.568 * 1e-5; % fluid kinematic viscosity, m^2/s
            warning('these constants not verified yet (10/24/2016)')
        case 'gypsum-air'
            con.g = 9.81; % gravitational constant
            con.rho_f = 1.225; % fluid density, kg/m^3
            con.rho_s = 2308; % particle density, kg/m^3
            con.nu = 1.568 * 1e-5; % fluid kinematic viscosity, m^2/s
            warning('these constants not verified yet (10/24/2016)')
    end
    con.R = (con.rho_s - con.rho_f) / con.rho_f;
end
