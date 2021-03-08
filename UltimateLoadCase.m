%Ultimate load case, must run limit load case first
Fcy = 48; %ksi
Ftu = 68; %ksi
E = 10.9e3; %ksi
tStr = 0.05943; %inches
B = 4.05;
m = 0.82;
Along = Ast*1.25; %longeron area
tLong = tStr*1.25; %longeron thickness, inches, determined by stiffener cross section
My_ult = 5810780; %ftlbf ultimate case

% crippling stress of z or c formed sections
%stringer
sigma_cr_str = B*((1/(Ast/tStr^2))^m)*((E^m * Fcy^(3-m))^(1/3));

%longeron
sigma_cr_long = B*((1/(Along/tLong^2))^m)*((E^m * Fcy^(3-m))^(1/3));

%define which booms are stiffeners and longerons
%current: four corners
longLocs = zeros(1,4);
for i = 1:1:4
    if i ~= 4
        longLocs(i) = (booms/4)*i +1;
    else
        longLocs(i) = (booms/4)*i +1 - booms;
    end
end

%effectiveness factor
est = zeros(1,booms);

%area of stinger defined
AStrUlt = zeros(1,booms);
%compression side
for i = 1:1:booms/2
    if (i == longLocs(1) || i == longLocs(2) || i == longLocs(3) || i == longLocs(4))
        AStrUlt(i) = Along;
        est(i) = 1;
    else
        AStrUlt(i) = Ast;
        est(i) = sigma_cr_str/sigma_cr_long;
    end
end
%tension side
for i = booms/2+1:1:booms
    est(i) = 1;
    if (i == longLocs(1) || i == longLocs(2) || i == longLocs(3) || i == longLocs(4))
        AStrUlt(i) = Along;
    else
        AStrUlt(i) = Ast;
    end
end

%effective area around fuselage
Aeff = zeros(1,booms);
for i = 1:1:booms/2
    Aeff(i) = est(i)*(AStrUlt(i) + 1.90*tSkin^2*sqrt(E/sigma_cr_str));
end
for i = booms/2+1:1:booms
    Aeff(i) = AStrUlt(i) + ((tSkin*b)/6)*(4 + z(3)/z(2) + z(1)/z(2));
end

% weight estimate
AeffWeight = zeros(1,booms);
for i = 1:1:booms
    AeffWeight(i) = Aeff(i)*density; %lb/in
end
xSectWeight = sum(AeffWeight); %lb/in, weight in one fuselage cross section
fprintf('total cross sectional weight is %f lbf/in \n', xSectWeight);

%moment of inertia calc
Iy_ult = 0;
for i = 1:1:booms
    Iy_ult = Iy_ult + Aeff(i)*zSqr(i); %in^4
end

%bending moment stress calc
bendStress = zeros(1,booms);
for i = 1:1:booms
    bendStress(i) = (((My_ult*12) * z(i))/Iy_ult)*(-1); %lbf/in^2, neg in compression
end

%actual bending stress with effectiveness factor
actualStress = zeros(1,booms);
for i = 1:1:booms
    actualStress(i) = bendStress(i) * est(i);
end

%determine allowable stress in each stiffener, compression on top
allowStress = zeros(1,booms);
for i = 1:1:booms
    if i <= booms/2
        allowStress(i) = Fcy*1000; %psi
    else
        allowStress(i) = Ftu*1000; %psi
    end
end

%determine margin of safety
MS = zeros(1,booms);
for i = 1:1:booms
    MS(i) = allowStress(i)/abs(actualStress(i)) - 1;
end

minMS = min(MS);
fprintf('Minimum MS is %f \n', minMS);