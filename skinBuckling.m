% Determine when the skin panels buckle in compression, shear, and bending
% Assumes simply supported edges, elastic range
% kc = compression buckling coefficient
% ks = shear buckling coefficient
% kb = bending buckling coefficient
% ve = poisson's ratio
% t = plate thickness
% b = short dimension of plate = stiffener spacing

function [sigma_comp,tau_shear,sigma_bend] = skinBuckling(kc,ks,kb,t,E,ve,b)

    % buckling of plates in compression
    sigma_comp = ((kc*pi^2*E)/(12*(1-ve^2)))*(t/b)^2;
    
    % buckling under shear
    tau_shear = ((ks*pi^2*E)/(12*(1-ve^2)))*(t/b)^2;
    
    % buckling due to bending loads
    sigma_bend = ((kb*pi^2*E)/12*(1-ve^2))*(t/b)^2;
    
end

