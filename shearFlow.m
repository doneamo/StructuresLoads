% calculate shearflow based on idealized fuselage cross section 
% Vy = 0, Iyz = 0
% negative indicates counter-clockwise moment
% Vz in lbf, Iy in in^4, A in in^2, z in inches, r in inches
% T_ft in ft lbf
function [q,tau] = shearFlow(Vz,Iy,A,z,numBooms,t,r,T_ft)

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
    qs = zeros(1,numBooms);
    for i= 1:1:numBooms
        qs(i) = qb(i) + qso; %lb/in
    end
    
    %calc shear flow due to torsion
    A_fuselage = pi*r^2; %in^2
    T_in = T_ft * 12; %in lbf
    qt = T_in/(2*A_fuselage);
    
    %calc final total shear flow
    %assumes torsion comes from left landing gear by pilot's POV
    q = zeros(1,numBooms);
    for i = 1:1:numBooms
        q(i) = qs(i) + qt;
    end
    
    maxq = max(q); %lb/in
    tau = maxq/t/1000; %ksi
end

