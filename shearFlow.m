% calculate shearflow based on idealized fuselage cross section 
% Vy = 0, Iyz = 0
% negative indicates counter-clockwise moment
% Vz in lbf, Iy in in^4, A in in^2, z in inches
function [q,tau] = shearFlow(Vz,Iy,A,z,numBooms,t)

    %calc qb
    qb = zeros(1,numBooms);
    qb(1) = (-Vz/Iy)*A*z(1);
    for i = 2:1:(numBooms-1)
        qb(i) = (-Vz/Iy)*A*z(i) + qb(i-1); %lb/in
    end
    
    %calc moment due to qb
    A_qb = A/numBooms;
    Mqb = zeros(1,numBooms);
    for i = 1:1:numBooms
        Mqb(i) = 2*qb(i)*A_qb; %lb in
    end
    Mqb_total = sum(Mqb);
    
    %calc moment due to shear force
    Mv = 0; %assumed shear force applied at shear center
    
    %calc qso
    qso = (Mv - Mqb_total)/(2*A); %lb/in
    
    %calc total qs -> q
    q = zeros(1,numBooms);
    for i= 1:1:numBooms
        q(i) = qb(i) + qso; %lb/in
    end
    
    maxq = max(q); %lb/in
    tau = maxq/t; %lb/in^2
end

