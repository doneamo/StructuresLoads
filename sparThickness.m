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
density = 0.101; %lbf/in^3
Mx = 988723 * 1.5; %bending moment at root
critStress = 78; %crtical stress based on material, ksi

size = 0; %size of array

%determie size of array based on how many data points
for i = minT:increment:maxT
   size = size+1; 
end

%create arrays for data
appliedStress = zeros(1,size);
MSI = zeros(1,size); %y axis of fig 1, safety margin of I beam
thickness = minT:increment:maxT; %x axis, thickness
weight = zeros(1,size); %weight based on material

%calc MS
counter = 0;
for t = minT:increment:maxT
    counter = counter + 1;
    
    %calc Iz of I beam
    Iz_Ibeam = IBeamIz(t, 2*t, maxWidth, maxHeight);
    
    %calc volume of I beam based on density of material
    vol_IBeam = IBeamVol(t, 2*t, maxWidth, maxHeight);
    
    %calc applied stress
    appliedStress(1,counter) = Mx*yC / Iz_Ibeam /1000; %ksi
    
    %calc weight of I beam based on material
    weight(1,counter) = density * vol_IBeam;
    
    %calc the margin of safety
    MSI(1,counter) = critStress/appliedStress(1,counter) - 1;
    
end

%%%%%%%%%%%%%%%%%%%%% PLOTTING

%MS vs thickness
figure(1)
plot(thickness, MSI,'k^-', 'MarkerIndices', 2:2:length(MSI)) %I beam
grid on
xlabel('Thickness [in]')
ylabel('Margin of Safety')

figure(2)
plot(thickness, weight,'k^-', 'MarkerIndices', 2:2:length(weight)) %thickness vs weight
grid on
xlabel('Thickness [in]')
ylabel('Weight [lb_f/in]')

%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS

%calc the Iz of an Ibeam, assuming symmetrical
function [Iz] = IBeamIz (tWeb, tFlange, width, height)

    Iz1 = (tWeb * (height-2*tFlange)^3)/12 + 0; %Iz for middle web
    Iz2 = (width * tFlange^3)/12 + (tFlange * width)*(tFlange/2 - height/2)^2; %Iz for top and bottom flange

    Iz = Iz1 + 2*Iz2;
    
end

%calculate volume I beam, equal thickness, symmetrical
function [vol] = IBeamVol (tWeb, tFlange, width, height)
    vol = 2*(tFlange*width) + (height - (2*tFlange))*tWeb;
end



