function backwater_fixed_qs_exner_time
    L = 1200e3; % length of domain (m)
    nx = 400; % number of nodes (+1)
    dx = L/nx; % length of cells (m)
    x = 0:dx:L; % define x-coordinates
    
    start = 63; % pin-point to start eta from (m)
    S0 = 7e-5; % bed slope
    eta = linspace(start, start - S0*(nx*dx), nx+1); % channel bed values
    H0 = 0; % fixed base level (m)
    Cf = 0.0047; % friction coeff
    
    B0 = 1100; % channel width
    Qw = 10000; % water discharge
    qw = Qw / B0; % width averaged water discharge
    
    d50 = 300e-6; % median grain diameter;
    Beta = 0.64; % adjustment factor, Nittrouer and Viparelli, 2014
    
    au = 1; % winding coefficient
    
    phi = 0.6; % bed porosity
    If = 0.2; % intermittency factor, i.e., fraction of flooding Qw per year
    
    T = 500; % yrs
    timestep = 0.1; % timestep, fraction of years
    t = T/timestep; % number of timesteps
    dtsec =  31557600 * timestep; % seconds in a timestep
    
    etai = eta;
    
    for i = 1:t
        [S] = get_slope(eta, nx, dx); % bed slope at each node
        [H] = get_backwater_fixed(eta, S, H0, Cf, qw, nx, dx); % flow depth
        U = Qw ./ (H .* B0); % velocity
        [qs] = get_transport(U, Cf, d50, Beta);
        qsu = qs(1); % fixed equilibrium at upstream
        [dqsdx] = get_dqsdx(qs, qsu, nx, dx, au);
        [eta] = update_eta(eta, dqsdx, phi, If, dtsec);
    end
    
    CFL = max(U)*(dtsec)/dx;
    
    makeplot = true; % set to false for no plotting
    if makeplot
        figure()
            cla; hold on;
            etaiLine = plot(x/1000, etai, 'k-', 'LineWidth', 0.8);
            etaLine = plot(x/1000, eta, 'k-', 'LineWidth', 1.2);
            Hline = plot(x/1000, eta + H, 'b-', 'LineWidth', 1.2);
            xlabel('distance downstream (km)')
            ylabel('elevation (m)')
            legend([etaLine, Hline], {'channel bed', 'water surface'})
            box on
            set(gca, 'FontSize', 10, 'LineWidth', 1.5)

    end
    
end

function [dqsdx] = get_dqsdx(qs, qsu, nx, dx, au)
    dqsdx = NaN(1, nx+1);% preallocate
    dqsdx(nx+1) = (qs(nx+1) - qs(nx)) / dx; % gradient at downstream boundary, downwind always
    dqsdx(1) = au*(qs(1)-qsu)/dx + (1-au)*(qs(2)-qs(1))/dx; % gradient at upstream boundary (qt at the ghost node is qt_u)
    dqsdx(2:nx) = au*(qs(2:nx)-qs(1:nx-1))/dx + (1-au)*(qs(3:nx+1)-qs(2:nx))/dx; % use winding coefficient in central portion
end

function [eta] = update_eta(eta, dqsdx, phi, If, dtsec)
    eta0 = eta;
    eta = eta0 - ((1/(1-phi)) .* dqsdx .* (If * dtsec));
end


function [qs] = get_transport(U, Cf, d50, Beta)
    % return sediment transport at capacity per unit width
    % 1000 = rho = fluid density
    % 1.65 = R = submerged specific gravity
    % 9.81 = g = gravitation acceleration
    ustar = sqrt(Cf .* (U.^2));
    tau = 1000 .* (ustar.^2); 
    
    qs = Beta .* sqrt(1.65 * 9.81 * d50) * d50 * (0.05 / Cf) .* (tau ./ (1000 * 1.65 * 9.81 * d50)) .^ 2.5; 
end

function [S] = get_slope(eta, nx, dx)
    % return slope of input bed (eta)
    S = zeros(1,nx+1);
    S(1) = (eta(1) - eta(2)) / dx;
    S(2:nx) = (eta(1:nx-1) - eta(3:nx+1)) ./ (2*dx);
    S(nx + 1) = (eta(nx) - eta(nx + 1)) / dx;
end
    
function [H] = get_backwater_fixed(eta, S, H0, Cf, qw, nx, dx)
    % backwater formulated for fixed width
    H = NaN(1,nx+1); % preallocate depth 
    H(nx+1) = abs(H0 - eta(nx+1)); % water depth at downstream boundary
    for i = nx:-1:1
        % predictor step: computation of a first estimation of the water depth Hp
        Frsqp = get_froudesq(qw, H(i+1)); % calculate froude-squared from conditions at i+1
        dHdxp = get_dHdx(S(i+1), Cf, Frsqp); % use desired relation for dHdx (width fixed for now)
        Hp = H(i+1) - dHdxp * dx; % solve for H prediction
        % corrector step: computation of H
        Frsqc = get_froudesq(qw, Hp); % calculate froude-squared at i with prediction depth
        dHdxc = get_dHdx(S(i), Cf, Frsqc); % doaa
        % convolution of prediction and correction, trapezoidal rule
        H(i) = H(i+1) - ( (0.5) * (dHdxp + dHdxc) * dx );
    end
end

function [Frsq] = get_froudesq(qw, H)
    % calculate froude squared
    g = 9.81; % gravitational acceleration constant
    Frsq = ( qw^2 / (g * H^3) );
end

function [dHdx] = get_dHdx(S_loc, Cf, Frsq)
    % calculate change in height over space by backwater eqn
    dHdx = (S_loc - Cf * (Frsq)) / (1 - (Frsq));
end