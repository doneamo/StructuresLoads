function [sigmaH,sigmaL] = hoopStress(p,r,t)
    sigmaH = (p*r)/t;
    sigmaL = (p*r)/(2*t);
end

