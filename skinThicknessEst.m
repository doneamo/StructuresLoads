% Description: Calculates the skin thickness based on given boom area

% r in inches
% z: vector of boom loctions in inches from horizontal centreline
% theta: angle between cloest two booms

function [t,A_st,b] = skinThicknessEst(z, theta, r, A_eq, A_max, A_min)
    b = r * deg2rad(theta); %arc length between booms
    b
    A_count = A_min;
    numElements = 0;
    
    while(A_count < A_max)
        A_count = A_count + 0.001;
        numElements = numElements + 1;
    end
    
    A_st = zeros(1,numElements);
    t = zeros(1,numElements);
    
    %fill stiffener area array
    A_st(1) = A_min;
    for i = 2:1:numElements
        A_st(i) = A_st(i-1) + 0.001;
    end
    
    %calcualte thickness
    for i = 1:1:numElements
        t(i) = (6*(A_eq - A_st(i)))/(b*(4 + (z(1)/z(2)) + (z(3)/z(2))));
    end
end

