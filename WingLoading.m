
 %Plot lift distribution for Q4.1
 m = 381;
 
 %Generate wing station vector
 y = zeros(1,m);
 for i = 1:1:m
     y(1,i) = -0.125 + 0.125*i;
 end
 disp(y)

 %Generate lift vector
 L = zeros(1,m);
 for j = 1:1:m
     L(1,j) = 21.15*(sqrt(2256.3 - y(1,j)^2)) - 14.25*y(1,j) + 1127.8;
 end
 disp(L)
 
 %Close off the distribution
 close = zeros(1,2);
 for a = 1:1:2
     close(1,a) = 47.5;
 end
 L_close = zeros(1,2);
 for b = 1:1:2
     L_close(1,b) = -455.7 + 455.7*b;
 end
 
  %Generate Elliptical Distribution
 Ellipse = zeros(1,m);
  for c = 1:1:m
     Ellipse(1,c) = 42.3*sqrt(2256.3-y(1,c)^2);
 end
 
 %Generate Trapezoidal Distribution
 Trap = zeros(1,m);
 for d = 1:1:m
     Trap(1,d) = -28.5*y(1,d) + 2255.6;%
 end
 %Close off trapezoidal distribution
 D = zeros(1,2);
 for f = 1:1:2
     D(1,f) = 47.5;
 end
 C = zeros(1,2);
 for e = 1:1:2
     C(1,e) = -902.3 + 902.3*e;
end
 
 plot(y,L,'k')
 hold on
 plot(y,Ellipse,'r')
 hold on
 plot(y,Trap,'b')
 hold on
 plot(D,C,'b')
 grid on
 plot(close,L_close,'k')
 hold on
 grid minor
 xlabel('Wing Station,y [ft]')
 ylabel('Lift, L(y) [lb_f]')
 legend('Shrenk''s Approximation','Elliptical Distribution','Trapezoidal Approximation','Location','northeast')
 legend('boxoff')


% Create moment,shear and torsion diagrams for Q4.2

