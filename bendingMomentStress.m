% Calculates the bending moment stress
% My in lbf ft, r in inches, Iy in in^4
function [sigmaV] = bendingMomentStress(My,r,Iy)
    My_in = My * 12;
    sigmaV = ((My_in * r)/Iy)/1000; %ksi
end

