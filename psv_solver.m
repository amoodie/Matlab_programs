% Andrew J. Moodie
% November 2014
% following formulation from Deitrich, 1982
% function takes a grain size in microns
% function returns a particle settling velocity in m/s

function w_s = psv_solver(D)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%        Solve for PSVs         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % declare all the knowns
    rho_s = 2650; % kg/m^3
    rho_f = 1000; % kg/m^3
    nu = 1.307 * 10e-6; % m^2/s
    grav = 9.81; % m/s^2
    CSF = 0.7; % Corey shape factor
    Pow = 3.5; % powers function

    % solve for a given D
    D_met = D / (1e6); % convert to meters
    D_a = ((rho_s - rho_f) * grav * (D_met ^ 3)) / (rho_f * (nu ^ 2)); % convert to a D_a, unitless (using D_met)

    % solve for PSV based on D_a
    R_1 = -3.76715 + (1.92944 * (log10(D_a))) - (0.09815 * (log10(D_a)^(2.0))) - (0.000575 * (log10(D_a)^(3.0))) + (0.00056 * (log10(D_a)^(4.0)));

    R_2 = (log10(1-((1-CSF)/0.85))) - (((1-CSF)^(2.3)) * (tanh(log10(D_a)-4.6))) + ((0.3) * (0.5-CSF) * ((1-CSF)^(2.0)) * (log10(D_a)-4.6));

    R_3 = ((0.65) - ((CSF/2.83) * (tanh(log10(D_a)-4.6))))^(1 + ((3.5 - Pow)/2.5));

    w_a = R_3 * (10^(R_1 + R_2));
    w_s = nthroot(((w_a * (rho_s-rho_f) * grav * nu) / rho_f),3);
end