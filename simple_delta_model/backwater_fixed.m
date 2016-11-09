function backwater_fixed
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
    Qw = 35000; % water discharge
    qw = Qw / B0; % width averaged water discharge
    
    [S] = get_slope(eta, nx, dx); % bed slope at each node

    [H] = get_backwater_fixed(eta, S, H0, Cf, qw, nx, dx); % flow depth
    
    makeplot = true; % set to false for no plotting
    if makeplot
        figure()
        cla; hold on;
        etaLine = plot(x/1000, eta, 'k-', 'LineWidth', 1.2);
        Hline = plot(x/1000, eta + H, 'b-', 'LineWidth', 1.2);
        xlabel('distance downstream (km)')
        ylabel('elevation (m)')
        legend([etaLine, Hline], {'channel bed', 'water surface'})
        box on
        set(gca, 'FontSize', 10, 'LineWidth', 1.5)
    end
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
        Frp = get_froude(qw, H(i+1)); % calculate froude from conditions at i+1
        dHdxp = get_dHdx(S(i+1), Cf, Frp); % use desired relation for dHdx (width fixed for now)
        Hp = H(i+1) - dHdxp * dx; % solve for H prediction
        % corrector step: computation of H
        Frc = get_froude(qw, Hp); % calculate froude at i with prediction depth
        dHdxc = get_dHdx(S(i), Cf, Frc); % doaa
        % convolution of prediction and correction, central diffs
        H(i) = H(i+1) - ( (0.5) * (dHdxp + dHdxc) * dx );
    end
end

function [Fr] = get_froude(qw, H)
    g = 9.81; % gravitational acceleration constant
    Fr = ( qw^2 / (g * H^3) );
end

function [dHdx] = get_dHdx(S_loc, Cf, Fr)
    dHdx = (S_loc - Cf * (Fr^2)) / (1 - (Fr^2));
end