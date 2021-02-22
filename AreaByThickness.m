% calculate the area of the stringer based on the skin thickness required
% z in inches
% t in inches
% b in inches
% Aeq in in^2

function [Aeq_Ast] = AreaByThickness(t,b,z)
    Aeq_Ast = ((t*b)/6)*(4 + z(3)/z(2) + z(1)/z(2));
end

