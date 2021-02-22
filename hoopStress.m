% Calculates the hoop stress, circumferencial and logitudinal
% P in lbf/ft^2, r in ft, tReq in inches
function [sigmaH,sigmaL] = hoopStress(p,r,t)
    P_in = p/144; %lbf/in^2
    r_in = r * 12; %inches
    sigmaH = ((P_in*r_in)/t)/1000; %ksi
    sigmaL = ((P_in*r_in)/(2*t))/1000; %ksi
end

