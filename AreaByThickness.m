% calculate the area of the stringer based on the skin thickness required
% z in inches
% t in inches
% b in inches
% Aeq in in^2

function [TotalArea] = AreaByThickness(t,b,z)
    TotalArea = ((t*b)/6)*(4 + z(3)/z(2) + z(1)/z(2));
end

