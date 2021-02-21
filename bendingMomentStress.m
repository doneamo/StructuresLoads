function [sigmaV] = bendingMomentStress(My,r,Iy)
    sigmaV = (My * r)/Iy;
end

