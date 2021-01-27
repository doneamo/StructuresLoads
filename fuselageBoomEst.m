% File name: fuselageBoomEst.m
% Author: Jen Tan
% Date: Jan. 21, 2021

% Description: Calculates the required boom area based on number of booms.
% Only for circular fuselages.
% Number of booms must be in multiples of 4, with booms at the lines of
% symmetry, evenly spaced in between. Assumes symmetrical cross section.

%removes all new line characters and replaces them with a space
%My in ft lbf
%r_ft radius in ft
%F_case in ksi
function [area] = fuselageBoomEst (My, r_ft, F_case, numBooms)

    %determine theta as the smallest angle in deg from horizontal
    theta = 90/(numBooms/4); %degrees
    fprintf("theta is " + theta + "\n");
    
    r_in = r_ft*12; %convert to inches
    fprintf("r inches is " + r_in + "\n");
    
    %get locations of each boom from horizontal 
    z = zeros(1, numBooms);
    for i = 1:1:(numBooms-1)
        z(1+i) = r_in*sind(i * theta);
    end
    
    %square locations
    zSqr = z.^2;
    
    zTotal = sum(zSqr);
    
    %F_ft = F_case*1000*144; %converts to lbf/ft^2
    
    area = (((My*12) * r_in)/(F_case*1000 * zTotal)); %in^2

end

