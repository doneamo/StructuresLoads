%calls fuselage boom estimate function and plots it

My = 4e6;
r = 7.5;
Fty = 50;
testCases = 20;
numBooms = zeros(1,testCases);
areas = zeros(1,testCases);

for i = 1:1:testCases
    numBooms(i) = i*4;
end

for i = 1:1:testCases
    areas(i) = fuselageBoomEst(My,r,Fty,numBooms(i));
end

%graph
figure(1)
plot(numBooms, areas, 'k')
hold on
grid on
xlabel('Number of Booms')
ylabel('Area of Booms, [in^2]')
    



