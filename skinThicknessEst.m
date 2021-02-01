% Description: Calculates the skin thickness based on given boom area

% r in inches
% z: vector of boom loctions in inches from horizontal centreline
% theta: angle between cloest two booms

function [t] = skinThicknessEst(z, theta, r, A_eq, A_max, A_min)
    b = r * deg2rad(theta); %arc length between booms
    
end

