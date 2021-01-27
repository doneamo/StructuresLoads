%calls fuselage boom estimate function and plots it

%varaibles
My = 4200000; %lbf ft
r = 7.5; %ft
Fty = 50; %ksi
testCases = 10;
density = 0.1; %lb/in^3, density of material

numBooms = zeros(1,testCases);
areas = zeros(1,testCases);
weight = zeros(1,testCases);

%calc area of booms req
for i = 1:1:testCases
    numBooms(i) = i*4;
end

for i = 1:1:testCases
    areas(i) = fuselageBoomEst(My,r,Fty,numBooms(i)); %in^2
    
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


