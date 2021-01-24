% File name: fuselageBoomEst.m
% Author: Jen Tan
% Date: Jan. 21, 2021

% Description: Calculates the required boom area based on number of booms.
% Only for circular fuselages.
% Number of booms must be in multiples of 4, with booms at the lines of
% symmetry, evenly spaced in between. Assumes symmetrical cross section.


function [] = fuselageBoomEst()

    area = fuselageBoomEstMethod (4e6, 7.5, 50, 8);
    fprintf("area is " + area + "\n");
    
end

%removes all new line characters and replaces them with a space
%My in ft x lbf
%r_ft radius in ft
%F_case in ksi
function [area] = fuselageBoomEstMethod (My, r_ft, F_case, numBooms)

    %determine theta as the smallest angle in deg from horizontal
    theta = 90/(numBooms/4); %degrees
    fprintf("theta is " + theta + "\n");
    
    r_in = r_ft*12; %convert to inches
    fprintf("r is " + r_in + "\n");
    
    %get locations of each boom from horizontal 
    z = zeros(1, numBooms);
    for i = 1:1:(numBooms-1)
        z(1+i) = r_in*sind(i * theta);
    end
    
    z
    
    fprintf("numBooms is " + numBooms + "\n");
    
    zSqr = z.^2;
    zSqr
    
    zTotal = sum(zSqr);
    zTotal_ft = zTotal/12;
    
    F_ft = F_case*1000*144; %converts to lbf/ft^2
    
    area = ((My * r_ft)/(F_ft * zTotal_ft))*144; %in^2

end

