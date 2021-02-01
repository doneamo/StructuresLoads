%calls fuselage boom estimate function and plots it

%varaibles
My = 2290000; %lbf ft
r = 15.833/2; %ft,avg of inner and outer
Ft = 62; %ksi
testCases = 10;
density = 0.097; %lb/in^3, density of material

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

%graph
figure(1)
plot(numBooms, areas, 'k')
hold on
grid on
xlabel('Number of Booms')
ylabel('Area of Booms, [in^2]')
    
figure(2)
plot(numBooms, weight, 'k');
hold on
grid on
xlabel('Number of Booms')
ylabel('Weight Per Boom, [lb_f/in]')

%=========================================================================

%calc thickness for selected num of booms
booms = 8;
[area,z,theta] = fuselageBoomEst (My, r, Ft, booms);
areaArrayPos = booms/4;
A_max = areas(areaArrayPos); %area with 8 booms
A_min = areas(areaArrayPos+1); %area with 12 booms
[thickness, areaSt] = skinThicknessEst(z, theta, r, area, A_max, A_min);

%plot thickness cruve
figure(3)
plot(thickness,areaSt, 'k-');
hold on
grid on
xlabel('Skin Thickness, [in]')
ylabel('Area of Stiffeners, [in^2]')


