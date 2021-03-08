%Limit load case estimate
%varaibles =========================================================
%My = 2290000; %lbf ft ultimate load case
My = 3679540; %lbf ft limit load case
T = 113400; %ft lbf
Vz = 188700; %lbf
r = 15.833/2; %ft,avg of inner and outer
Ft = 62; %ksi
testCases = 80;
density = 0.097; %lb/in^3, density of material
internalP = 1696; %lbf/ft^2, internal pressure at 6000ft

fprintf('--------------------- \n'); 

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
booms = 100;
fprintf('num of booms is %d \n', booms); 
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
tSkin = 0.05; %in
fprintf('skin thickness is %f in \n', tSkin);
Aeq_Ast = AreaByThickness(tSkin,b,z);
Ast = area;
Aeq = Ast + Aeq_Ast;
fprintf('Ast is %f in^2 \n', Ast); 
fprintf('Aeq is %f in^2 \n', Aeq); 

%weight per boom with equivalent area
weightEq = Aeq * density;
fprintf('weightEq is %f lbf/in \n', weightEq); 

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

% Mohr's circle calcs ===================================

% calc shear flow
[q,tau] = shearFlow(Vz,Iy,Aeq,z,booms,tSkin,r_in,T);

% hoop stress, internalP in lbf/ft^2, r in ft, tReq in inches
[sigmaH,sigmaL] = hoopStress(internalP,r,tSkin);

% stress due to bending moment
sigmaV = bendingMomentStress(-My,r_in,Iy);

% define stress element
tauxy = tau;
sigmax = sigmaL + sigmaV;
sigmay = sigmaH;
fprintf('tauxy is %f ksi \n', tauxy); 
fprintf('sigmax is %f ksi \n', sigmax); 
fprintf('sigmay is %f ksi \n', sigmay); 

% Mohr's circle
[tau_max,thetaP,thetaTau,sigma1,sigma2,sigma3] = MohrsCircle(tauxy,sigmax,sigmay,internalP);

fprintf('sigma1 is %f ksi \n', sigma1); 
fprintf('sigma2 is %f ksi \n', sigma2); 
fprintf('sigma3 is %f ksi \n', sigma3); 
fprintf('thetaP is %f degrees \n', thetaP); 
fprintf('thetaTau is %f degrees \n', thetaTau); 
fprintf('tau_max is %f ksi \n', tau_max); 

% Tresca failure criterion
FS = Ft/(2*tau_max);
fprintf('safety factor is %f \n', FS); 






