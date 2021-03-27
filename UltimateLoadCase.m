%Ultimate load case, must run limit load case first
Fcy = 39; %ksi
%Fcy = 48;
Ftu = 68; %ksi
E = 10.5e3; %ksi
Ec = 10.7e3;
%tStr = 0.05943; %inches
Ast = area + 0.032;
tStr = Ast/(0.5+0.93+1.92+1.1);
Along = Ast*1; %longeron area
tLong = tStr*1; %longeron thickness, inches, determined by stiffener cross section
My_ult = 5810780; %ftlbf ultimate case

%shape of stiffeners
zFormed = true;
%jFormed = false;
jExtrude = false;

if zFormed == true
    % crippling stress of z or c formed sections
    % stringer
    % z and c formed
    B = 4.05; 
    m = 0.82;
    sigma_cr_str = B*((1/(Ast/tStr^2))^m)*((E^m * Fcy^(3-m))^(1/3));
    %longeron
    sigma_cr_long = B*((1/(Along/tLong^2))^m)*((E^m * Fcy^(3-m))^(1/3));
    fprintf('Z formed \n');
end

% if jFormed == true
%     % J formed
%     B = 0.58;
%     m = 0.8;
%     % crippling stress of J formed sections
%     g = 7; % 5 flanges, 2 cuts
%     sigma_cr_str = B*((1/(Ast/(g*tStr^2)))^m)*((E^m * Fcy^(2-m))^(1/2));
%     sigma_cr_long = B*((1/(Along/(g*tLong^2)))^m)*((E^m * Fcy^(2-m))^(1/2));
%     fprintf('J formed \n');
% end

if jExtrude == true
    %calculated from excel sheet
    %crippling stress of extuded section
    sigma_cr_str = 25.9; %ksi
    sigma_cr_long = 25.9; %ksi
    fprintf('J extruded \n');
end

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
Aactual = zeros(1,booms);
for i = 1:1:booms/2
    if (i == longLocs(1) || i == longLocs(2) || i == longLocs(3) || i == longLocs(4))
        Aeff(i) = est(i)*(AStrUlt(i) + 1.90*tSkin^2*sqrt(E/sigma_cr_long));
    else
        Aeff(i) = est(i)*(AStrUlt(i) + 1.90*tSkin^2*sqrt(E/sigma_cr_str));
    end
    Aactual(i) = Aeff(i)/est(i);
end
for i = booms/2+1:1:booms
    Aeff(i) = AStrUlt(i) + ((tSkin*b)/6)*(4 + z(3)/z(2) + z(1)/z(2));
    Aactual(i) = Aeff(i);
end

% weight estimate
AactaulWeight = zeros(1,booms);
for i = 1:1:booms
    AactaulWeight(i) = Aactual(i)*density; %lb/in
end
xSectWeight = sum(AactaulWeight); %lb/in, weight in one fuselage cross section
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
fprintf('Area of stiffener is %f \n', Ast);
fprintf('Thickness of stiffener is %f \n', tStr);

% ============================ Determine frame spacing
%determine centroid of stringer
elements = 4;
yi = [(0.93-tStr) + 1.10/2, (0.93-tStr) + tStr/2, 0.93/2, tStr/2];
zi = [tStr/2, 1.92/2, 1.92-(tStr/2), 1.92-((0.5-tStr)/2 + tStr)];
Ai = [1.1*tStr, (1.92-(tStr*2))*tStr, 0.93*tStr, (0.5-tStr)*tStr];
yiXAi = yi.*Ai;
ziXAi = zi.*Ai;

ybar = sum(yiXAi)/sum(Ai);
zbar = sum(ziXAi)/sum(Ai);

%moment of intertia of stiffener x section
Adz2 = zeros(1,elements);
for i = 1:1:elements
    Adz2(i) = Ai(i)*(zbar - zi(i))^2;
end
IyArray = [(1.1*tStr^3)/12 + Adz2(1),...
    (tStr*(1.92 - 2*tStr)^3)/12 + Adz2(2),...
    (0.93*tStr^3)/12 + Adz2(3),...
    (tStr*(0.5-tStr)^3)/12 + Adz2(4)];
Iy = sum(IyArray); %in^4

Ady2 = zeros(1,elements);
for i = 1:1:elements
    Ady2(i) = Ai(i)*(ybar - yi(i))^2;
end
IzArray = [(tStr*1.1^3)/12 + Ady2(1),...
    ((1.92-2*tStr)*tStr^3)/12 + Ady2(2),...
    (tStr*0.93^3)/12 + Ady2(3),...
    ((0.5-tStr)*tStr^3)/12 + Ady2(4)];
Iz = sum(IzArray); %in^4

if Iy < Iz
    Imin = Iy;
else
    Imin = Iz;
end

rho = sqrt(Imin/Ast);

%Euler buckling eqn
c = 4; %end fixity both fixed
%L = rho*sqrt((c*pi^2*E)/abs(sigmax))
L = 24;
critical = (c*pi^2*E)/(L/rho)^2;
fprintf('Critical compressive load is %f \n', critical);

% % %=================================================
% %skin buckling
% a = L;
% sheetAR = a/b;
% fprintf('Sheet AR is %f \n', sheetAR);
% % determined by graphs based on sheet AR
% kc = 3.62;
% ks = 5.8;
% kb = 0;
% ve = 0.33;
% [sigma_comp,tau_shear,sigma_bend] = skinBuckling(kc,ks,kb,0.061,E,ve,b);
% 
% Rc = sigma_comp/Fcy;
% Rs = tau_shear/Ft;
% MS_skin = 2/(Rc + sqrt(Rc^2 + 4*Rs^2)) - 1;
% fprintf('Skin MS is %f \n', MS_skin);








