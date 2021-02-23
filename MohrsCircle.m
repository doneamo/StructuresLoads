% calculates the maximum shear stress and principal stresses using Mohrs
% circle method
% All inputs in ksi, except P in lbf/ft^2
% Theta output is in degrees, positive = CW, negative = CCW as with Mohr's
% circle convention
% All other outputs in ksi

function [tau_max,thetaP,thetaTau,sigma1,sigma2,sigma3] = MohrsCircle(tau_xy,sigma_x,sigma_y,P)
    
    thetaP = (atand(tau_xy/((sigma_x-sigma_y)/2)))/2; %principal stress theta
    thetaTau = (atand((-(sigma_x-sigma_y)/2)/tau_xy))/2; %max shear stress theta
    
    R12 = sqrt(((sigma_x-sigma_y)/2)^2 + tau_xy^2);
    
    sigma1 = (sigma_x + sigma_y)/2 + R12;
    sigma2 = (sigma_x + sigma_y)/2 - R12;
    %sigma3 = -P/144/1000; %ksi
    sigma3 = 0; %ksi
    
    if (sigma3 <= sigma2)
        R13 = (sigma1 - sigma3)/2;
        tau_max = R13;
    else
        sigma3 = sigma2;
        sigma2 = 0;
        tau_max = R12;
    end

end

