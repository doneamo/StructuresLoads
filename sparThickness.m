% File name: template.m
% Author: Jen Tan
% Date: Nov. 5, 2020
% Description: To graph MS vs thickness of various types of spar
% strucutres, as well as weight vs thickness depending on material type

%variables
minT = 0.05; %min thickness considered, in
maxT = 0.25; %max thickness considered, in
increment = 0.01; %increment between each thickness considered, in
maxHeight = 13.77; %max allowable height of spar, in
maxWidth = 9.5; %max allowable width of spar, in
yC = maxHeight/2; %centroid loc in y axis
Mx = 988723*1.5; %3.12e7; %bending moment at root, lbf in

%material variables
density = 0.101; %lbf/in^3
critStress = 78; %crtical stress based on material, ksi

size = 0; %size of array

%determie size of array based on how many data points
for i = minT:increment:maxT
   size = size+1; 
end

%create arrays for data
thickness = minT:increment:maxT; %x axis, thickness
appStressI = zeros(1,size); %I beam
appStressB = zeros(1,size); %box beam
MSI = zeros(1,size); %y axis of fig 1, safety margin of I beam
MSB = zeros(1,size); %box beam
weightI = zeros(1,size); %weight based on material of I beam
weightB = zeros(1,size); %box beam

%calc MS
counter = 0;
for t = minT:increment:maxT
    counter = counter + 1;
    
    %calc Iz
    Iz_Ibeam = IBeamIz(t, 2*t, maxWidth, maxHeight);
    Iz_Bbeam = BoxBeamIz(t, 2*t, maxWidth, maxHeight);
    
    %calc volume based on density of material
    vol_IBeam = IBeamVol(t, 2*t, maxWidth, maxHeight);
    vol_BBeam = BoxBeamVol(t, 2*t, maxWidth, maxHeight);
    
    %calc applied stress
    appStressI(1,counter) = Mx*yC / Iz_Ibeam /1000; %ksi
    appStressB(1,counter) = Mx*yC / Iz_Bbeam /1000; %ksi
    
    %calc weight based on material -----
    weightI(1,counter) = density * vol_IBeam;
    weightB(1,counter) = density * vol_BBeam;
    
    %calc the margin of safety based on material ----
    MSI(1,counter) = critStress/appStressI(1,counter) - 1;
    MSB(1,counter) = critStress/appStressB(1,counter) - 1;
    
end

%%%%%%%%%%%%%%%%%%%%% PLOTTING

%MS vs thickness
figure(1)
plot(thickness, MSI,'k^-', 'MarkerIndices', 2:2:length(MSI)) %I beam
grid on
hold on
plot(thickness, MSB,'ko-', 'MarkerIndices', 2:2:length(MSB)) %box beam
xlabel('Thickness [in]')
ylabel('Margin of Safety')
legend('I-beam', 'Box Beam', 'Location', 'NorthWest')

figure(2)
plot(thickness, weightI,'k^-', 'MarkerIndices', 2:2:length(weightI)) %thickness vs weight
grid on
hold on
plot(thickness, weightB,'ko-', 'MarkerIndices', 2:2:length(weightB))
xlabel('Thickness [in]')
ylabel('Weight [lb_f/in]')
legend('I-beam', 'Box Beam','Location', 'NorthWest')

%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS

%calc the Iz of an Ibeam, symmetrical
function [Iz] = IBeamIz (tWeb, tFlange, width, height)

    Iz1 = (tWeb * (height-2*tFlange)^3)/12 + 0; %Iz for middle web
    Iz2 = (width * tFlange^3)/12 + (tFlange * width)*(tFlange/2 - height/2)^2; %Iz for top and bottom flange

    Iz = Iz1 + 2*Iz2;
    
end

%calculate area I beam, symmetrical
function [area] = IBeamVol (tWeb, tFlange, width, height)
    area = 2*(tFlange*width) + (height - (2*tFlange))*tWeb;
end

%calc the Iz of a box beam, symmetrical
function [Iz] = BoxBeamIz (tWeb, tFlange, width, height)

    IzWeb = (tWeb * (height - 2*tFlange)^3)/12 + 0; %left and right web
    IzFlange = (width * tFlange^3)/12 + (width*tFlange)*(height/2 - tFlange/2)^2;

    Iz = 2*IzWeb + 2*IzFlange;
    
end

%calc the area of box beam, symmetrical
function [area] = BoxBeamVol (tWeb, tFlange, width, height)
    area = 2*(tFlange*width) + 2*(height - (2*tFlange))*tWeb;
end


