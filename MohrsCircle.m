% calculates the maximum shear stress and principal stresses using Mohrs
% circle method
% All inputs in ksi
% Theta output is in degrees

function [tau_max,thetaP,thetaTau,sigma1,sigma2] = MohrsCircle(tau_xy,sigma_x,sigma_y)
    
    thetaP = (atand(tau_xy/((sigma_x-sigma_y)/2)))/2; %principal stress theta
    thetaTau = (atand((-(sigma_x-sigma_y)/2)/tau_xy))/2; %max shear stress theta
    
    tau_max = sqrt(((sigma_x-sigma_y)/2)^2 + tau_xy^2);
    
    sigma1 = (sigma_x + sigma_y)/2 + tau_max;
    sigma2 = (sigma_x + sigma_y)/2 - tau_max;

end

