Fcy = 48; %ksi
E = 10.9e3; %ksi
tStr = 0.0571; %inches
B = 4.05;
m = 0.82;
Along = Ast; %longeron area
tLong = tStr; %longeron thickness

% crippling stress of z or c formed sections
%stringer
sigma_cr_str = B*((1/(Ast/tStr^2))^m)*((E^m * Fcy^(3-m))^(1/3));

%longeron
sigma_cr_long = B*((1/(Along/tLong^2))^m)*((E^m * Fcy^(3-m))^(1/3));

%define which booms are stiffeners and longerons
%current: four corners
longLocs = zeros(1,4);
for i = 1:1:4
    longLocs(i) = (booms/4)*i;
end

%effectiveness factor
est = zeros(1,booms);

AStrUlt = zeros(1,booms);
for i = 1:1:booms
    if (i == longLocs(1) || i == longLocs(2) || i == longLocs(3) || i == longLocs(4))
        AStrUlt(i) = Along;
        est(i) = 1;
    else
        AStrUlt(i) = Ast;
        est(i) = sigma_cr_str/sigma_cr_long;
    end
end

%effective area around fuselage
Aeff = zeros(1,booms);
for i = 1:1:booms/2
    Aeff(i) = est(i)*(AStrUlt(i) + 1.90*tSkin^2*sqrt(E/sigma_cr_str));
end
for i = booms/2:1:booms
    Aeff(i) = AStrUlt(i) + ((tSkin*b)/6)*(4 + z(3)/z(2) + z(1)/z(2));
end

