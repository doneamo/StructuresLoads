% File name: fuselageBoomEst.m
% Author: Jen Tan
% Date: Jan. 21, 2021

% Description: Calculates the required boom area based on number of booms.
% Number of booms must be in multiples of 4, with booms at the lines of
% symmetry, evenly spaced in between. Assumes symmetrical cross section.

%removes all new line characters and replaces them with a space
function [area] = fuselageBoomEst (My, r, F_case, numBooms)

    %determine theta as the smallest angle in deg from horizontal
    theta = 90/(numBooms/4); %degrees
    
    %get locations of each boom from horizontal to 90 deg (upper right
    %corner)
    numBoomsCorner = numBooms/4 + 1;
    zCorner = zeros(1, numBoomsCorner);
    z = zeros(1, numBooms);
    
    zCorner(1) = 0;
    for i = 1:1:numBoomsCorner
        zCorner(i + 1) = r*sind(i * theta);
        z(1+i) = r*sind(i * theta);
    end
    
    %fill location for rest of booms
    %upper left corner
    i = numBoomsCorner + (numBoomsCorner-1);
    westPt = i;
    counter = 1;
    while(i > numBoomsCorner)
        z(i) = zCorner(counter);
        i = i-1;
        counter = counter + 1;
    end
    
    %bottom left corner
    i = westPt;
    counter = 1;
    while(i <= numBoomsCorner)
        i = i+1;
        counter = counter + 1;
        z(i) = zCorner(counter);
    end
    
    %bottom right corner
    i = westPt + numBooms/2 - 1;
    counter = 2;
    while(counter <= numBoomsCorner)
        z(i) = zCorner(counter);
        counter = counter + 1;
    end
    
    %square the z locs
    zSqr = zeros(1:numBooms);
    for i = 1:1:numBooms
        zSqr(i) = (z(i))^2;
    end
    
    zTotal = sum(zSqr);
    
    area = (My * r)/(F_case * zTotal);

end

