function [tau_T] = torsionalStress(T,rOut,t)
    rIn = rOut - t;
    J = (pi/2) * (rOut^4 - rIn^4);
    tau_T = (T*rOut)/J;
end

