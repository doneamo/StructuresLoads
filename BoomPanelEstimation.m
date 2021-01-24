Mz=3.5E6*12   %[lb*in]
l=0.15*13.8*12    %[in]

Ftu=zeros(1,50)   %[ksi]
for i=1:1:50
    Ftu(1,i)=40+i
end

AreaPerBoom=zeros(1,50)
for i=1:1:50
    AreaPerBoom(1,i)=Mz*(l/2)/(2*(l/2)^2*Ftu(1,i)*10^3)
end

figure(1)
plot(Ftu,AreaPerBoom)