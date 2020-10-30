
% Plot lift distribution for Q4.1
 m = 591;                %Nombre de point de donné
 Cr=17.15;               %Corde à l'emplenture [ft]
 Ct=10.3;                %Corde au bout d'aile [ft]
 nUltPos=3.25*1.5;           %Facteur de chargement limite positif
 b=118;                  %Envergure [ft]
 W=121368;               %Poids [lbf]
 B=2*W*nUltPos/b/(Cr+Ct);
 pente=(Ct-Cr)*2/b;
 
 %Matrice de l'envergure
 y = zeros(1,m);
 for i = 1:1:m
     y(1,i) = -b/2/(m-1) + b/2/(m-1)*i;
 end
 disp(y)

  %Generate Elliptical Distribution
 Ellipse = zeros(1,m);
  for c = 1:1:m
     Ellipse(1,c) =8*nUltPos*W/pi/b^2*sqrt((b/2)^2-y(1,c)^2);
 end
 
 %Generate Trapezoidal Distribution
 Trap = zeros(1,m);
 for d = 1:1:m
     Trap(1,d) = B*(pente*y(1,d) + Cr);%
 end
 
 % Generate lift vector with Shrenks approximation
 L = zeros(1,m);
 for j = 1:1:m
     L(1,j) = (Ellipse(1,j)+Trap(1,j))/2;
 end
 disp(L)
 
 %  %Close off the shrenk distribution
 close = zeros(1,2);
 for a = 1:1:2
     close(1,a) = b/2;
 end
 L_close = zeros(1,2);
 for f = 1:1:2
     L_close(1,f) = L(1,m)*(f-1);
 end
 
 %Close off trapezoidal distribution
%  D = zeros(1,2);
%  for f = 1:1:2
%      D(1,f) =  b/2;
%  end
%  C = zeros(1,2);
%  for e = 1:1:2
%      C(1,e) = (e-1)*Trap(1,m);
% end
  


%%%%%%%% Substracting the sutructure weight and the fuel weight%%%%%
Wwing=7747    %Poids des ailes [lbf]    les deux ailes

B1=-2*nUltPos*Wwing/(Cr+Ct)/b

 %Poids linéaire de la structure
 PoidsL = zeros(1,m);
 for g = 1:1:m
     PoidsL(1,g) = -2*nUltPos*Wwing/b/(Ct+Cr)*(2*(Ct-Cr)/b*y(1,g) + Cr);
 end
 
 %Poids linéaire de l'essence
 
 
 
 %%%%%%%%%%%%%%%%% Plotting section %%%%%%%%%%%%%%%%
  plot(y,L,'k')
  hold on
  plot(close,L_close,'k')
  hold on
  plot(y,PoidsL)
  hold on
%  plot(y,Ellipse,'r')
%  hold on
%  plot(y,Trap,'b')
%  hold on
%  plot(D,C,'b')
%  grid on
 grid minor
 xlabel('Wing Station,y [ft]')
 ylabel('Lift, l(y) [lb_f/ft]')


