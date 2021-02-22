% Calculates the bending moment stress
function [sigmaV] = bendingMomentStress(My,r,Iy)
    sigmaV = (My * r)/Iy;
end

