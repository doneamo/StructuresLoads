
 m = 591;                %Nombre de point de donné
 Cr=17.15;               %Corde à l'emplenture [ft]
 Ct=10.3;                %Corde au bout d'aile [ft]
 nUltPos=3.25*1.5;           %Facteur de chargement limite positif
 b=118;                  %Envergure [ft]
 W=121904;               %Poids [lbf]
 Wwing=7776/2;              %Poids de une aile [lbf]  
 Wfuel=27162.5;           %Poids du gaz pour une aile [lbf]
<<<<<<< HEAD
 Dfuselage=15.08;           %Diam�tre du fuselage
 WeightEngine=7768;         %Poids d'un moteur [lbf]
 Wpropeller=15560    
 Wpropulsion=3351
 WeightPropSyst=(WeightEngine+Wpropeller+Wpropulsion)/4            %Only 1 unit
 RadiusMotor=8.75;        %Diam�tre des h�lices
=======
 Dfuselage=15.08;        %Diamètre du fuselage
 WeightMotor=971;         %Poids d'un moteur [lbf]
 RadiusMotor=8.75;        %Diamètre des hélices
>>>>>>> 8ce3b530704595320c5dba60e0ced307386acb47
 yMotor1=1*RadiusMotor+Dfuselage/2;
 yMotor2=3*RadiusMotor+Dfuselage/2;
 
 %Matrice de l'envergure
 y = zeros(1,m);
 for i = 1:1:m
     y(1,i) = -b/2/(m-1) + b/2/(m-1)*i;
 end

  %Generate Elliptical Distribution
 Ellipse = zeros(1,m);
  for c = 1:1:m
     Ellipse(1,c) =8*nUltPos*W/pi/b^2*sqrt((b/2)^2-y(1,c)^2);
 end
 
 %Generate Trapezoidal Distribution
 Trap = zeros(1,m);
 B=2*W*nUltPos/b/(Cr+Ct);
 pente=(Ct-Cr)*2/b;
 for d = 1:1:m
     Trap(1,d) = B*(pente*y(1,d) + Cr);
 end
 
 % Generate lift vector with Shrenks approximation
 L = zeros(1,m);
 for j = 1:1:m
     L(1,j) = (Ellipse(1,j)+Trap(1,j))/2;
 end

 
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

 %Poids linéaire de la structure
 PoidsL = zeros(1,m);
 for g = 1:1:m
     PoidsL(1,g) = -2*nUltPos*Wwing/b/(Ct+Cr)*(2*(Ct-Cr)/b*y(1,g) + Cr);
 end
 
  %Poids linéaire de l'essence
  FuelW = zeros(1,m);
  for h = 1:1:m
      if (y(1,h)>8.5) && (y(1,h)<52)      %La valeur minimale est supposé 1ft après le diamètre 
                                          %et la valeur maximale 6ft avant le bout d'aile
      FuelW(1,h) = -2*nUltPos*Wfuel/b/(Ct+Cr)*(2*(Ct-Cr)/b*y(1,h) + Cr);
      else
      FuelW(1,h)=0;
      end
  end
 
%Substract the linear weight of the structure and the fuel from the
%shrenk's lift aproximation

 TrueLinearShearForce = zeros(1,m);
 for o = 1:1:m
     TrueLinearShearForce(1,o) = L(1,o)+PoidsL(1,o)+FuelW(1,o);
 end
 
 %%%%%%%%%%% Shear Stress and Moment equations %%%%%%%%%%%%%%%%

 ShearForce = zeros(1,m);
 for p = m-1:-1:1
     ShearForce(1,p) = TrueLinearShearForce(1,p)*b/2/(m-1)+ShearForce(1,p+1);
     if round(yMotor1,1)==y(1,p)
         ShearForce(1,p)=ShearForce(1,p)-2*WeightPropSyst*nUltPos;
     elseif round(yMotor2,1)==y(1,p)
         ShearForce(1,p)=ShearForce(1,p)-2*WeightPropSyst*nUltPos;
     end
 end
 
Moment = zeros(1,m);
 for q = m-1:-1:1
     Moment(1,q) = -ShearForce(1,q)*b/2/(m-1)+ Moment(1,q+1);
 end
 
 
 %%%%%%%%%%%%%%%%% Plotting section %%%%%%%%%%%%%%%%
 figure(1)
  plot(y,L,'k-+', 'MarkerIndices', 5:80:length(L)) %lift distribution
  hold on
  plot(y,PoidsL, 'k-o', 'MarkerIndices', 5:80:length(PoidsL)) %Wing Weight
  hold on
  plot(y,FuelW, 'k-^', 'MarkerIndices', 5:80:length(FuelW)) %Fuel Weight
  hold on
  plot(y, TrueLinearShearForce, 'k-s', 'MarkerIndices', 5:80:length(TrueLinearShearForce), 'LineWidth', 2) %combo
  hold on
  plot(close,L_close,'k') %to close off lift distribution
  hold on
%  plot(y,Ellipse,'r')
%  hold on
%  plot(y,Trap,'b')
%  hold on
%  plot(D,C,'b')
%  grid on
 grid on
 xlabel('Wing Station,y [ft]')
 ylabel('Wing Loading, [lb_f/ft]')
 legend('Lift Distribution', 'Wing Weight', 'Fuel Weight', 'Total Wing Loading')
 
 
 figure(2)
  plot(y, ShearForce, 'k')
  hold on
  grid on
 xlabel('Wing Station,y [ft]')
 ylabel('Wing Shear Force, [lb_f]')
 text(0, ShearForce(1,1),'\leftarrow V_z at wing root = ')

 figure(3)
  plot(y, Moment, 'k')
  hold on
   grid on
 xlabel('Wing Span ,y [ft]')
<<<<<<< HEAD
 ylabel('Moment, [lb_f] ft')
=======
 ylabel('Moment, [lb_f ft]')
 text(0, Moment(1,1),'\leftarrow M_x at wing root = ')
>>>>>>> 8ce3b530704595320c5dba60e0ced307386acb47
