%varaibles =========================================================
%My = 2290000; %lbf ft ultimate load case
My = 1709000; %lbf ft limit load case
T = 1274000; %ft lbf
Vz = 126000; %lbf
r = 15.833/2; %ft,avg of inner and outer
Ft = 62; %ksi
testCases = 80;
density = 0.097; %lb/in^3, density of material

% Inital boom area estimate ========================================

numBooms = zeros(1,testCases);
areas = zeros(1,testCases);
weight = zeros(1,testCases);

%calc area of booms req
for i = 1:1:testCases
    numBooms(i) = i*4;
end

for i = 1:1:testCases
    areas(i) = fuselageBoomEst(My,r,Ft,numBooms(i)); %in^2
    
    %calc total weight req
    weight(i) = density*areas(i); %lb/in
end

% %graph
% figure(1)
% plot(numBooms, areas, 'k')
% grid on
% xlabel('Nombre de Booms') %number of booms
% ylabel('Surface des Booms, [in^2]')%area of booms
% str = {'Matériel: 2198-T8','F_{ty} = 62ksi'};
% text(20,2,str)
    
% figure(2)
% plot(numBooms, weight, 'k');
% grid on
% xlabel('Number of Booms')
% ylabel('Weight Per Boom, [lb_f/in]')

% =================================================================
% Determine if thickness based on boom area simplification is enough for
% stifferner and skin

%calc thickness for selected num of booms
booms = 60;
r_in = r *12;
[area,z,theta] = fuselageBoomEst (My, r, Ft, booms);
areaArrayPos = booms/4;
A_max = areas(areaArrayPos); %boom area with 8 booms -> depends on booms
A_min = areas(areaArrayPos+1); %boom area with 12 booms
[thickness, areaSt, b] = skinThicknessEst(z, theta, r_in, area, A_max, A_min);

% %plot thickness cruve
% figure(3)
% plot(thickness,areaSt, 'k-');
% grid on
% % xlabel('Épaisseur du Revêtement, [in]') %skin thickness
% % ylabel('Surface des Raidisseurs , [in^2]') %area of stiffeners
% xlabel('Skin Thickness, [in]') %skin thickness
% ylabel('Area of Stiffeners , [in^2]') %area of stiffeners
%=========== Concluded the boom area calced before was not large
%enough, for both stringer and skin

% Skin thickness analysis ==========================================
% Stresses: hoop stress (longitudinal and circunfertial, bending moment
% stress, torsional stress, shear stress

% Calc area of stringer based on thickness req
tReq = 0.01896; %in
Aeq_Ast = AreaByThickness(tReq,b,z);
Ast = area;
Aeq = Ast + Aeq_Ast;

%moment of inertia calc
% rOut = r_in;
% rIn = rOut - tReq;
% Iy_web = (pi/4)*(rOut^4 - rIn^4); %in^4

zSqr = z.^2;
dzSqrTotal = sum(zSqr);
% Iy_boom = Ast*dzSqrTotal;

%Iy = Iy_web + Iy_boom;

% moment of inertia using new Aeq, idealized
Iy = Aeq*dzSqrTotal; %in^4

% calc shear flow
[q,tau] = shearFlow(Vz,Iy,Aeq,z,booms,tReq,r_in,T);






