%    SET UP ARRAYS AND MODEL VARIABLE
    clear all
    close all
    L=100;
    DMA=0.45;
    DMB=DMA;
    ko=1
    DRK=ko*sqrt(L/DMA)
    EAPP=-2
    E0=0
    n=1
    F=96485
    R=8.314
    T=298
    Enorm=(EAPP-E0)*(n*F)/(R*T)
    alpha=0.5
    reversible = 0
    
%    INITIAL CONDITIONS 

    FAOLD = zeros(L,1);
    FANEW = zeros(L,1);
    FBNEW = zeros(L,1);
    FBOLD = zeros(L,1);
    T = zeros(L,1);
    R = zeros(L,1);
    ZCOTT = zeros(L,1);
    Z=zeros(L,1);

    for J= 1:L 
    FAOLD(J)=1; 
    FANEW(J)=1;
    FBOLD(J)=0;
    FBNEW(J)=0;
    
    end 
    
%    START OF ITERATION LOOP 

K=0;
while K<L 
K=K+1;

%    DIFFUSION BEYOND THE FIRST BOX 
        for J=(2:L-1)
        FANEW(J)=FAOLD(J)+DMA*(FAOLD(J-1)-2*FAOLD(J)+FAOLD(J+1));
        FBNEW(J)=FBOLD(J)+DMA*(FBOLD(J-1)-2*FBOLD(J)+FBOLD(J+1));
        end 

%    DIFFUSION INTO THE FIRST BOX
    FANEW(1)=FAOLD(1)+DMA*(FAOLD(2)-FAOLD(1));
    FBNEW(1)=FBOLD(1)+DMB*(FBOLD(2)-FBOLD(1));
  

%    FARADAIC CONVERSION AND CURRENT FLOW 
    Z(K)=(ko*exp(-alpha*Enorm)*FANEW(1))-(ko*exp((1-alpha)*Enorm)*FBNEW(1));
    if Z(K)>=sqrt(L/DMA)*FANEW(1)
    Z(K)=sqrt(L/DMA)*FANEW(1);
    FANEW(1)=1/(1+exp(-Enorm));
    FBNEW(1)=1-FANEW(1);
    reversible=1;
    elseif Z(K)<0
    Z(K)=0;
    FANEW(1)=1;
    FBNEW(1)=0;
    elseif reversible>0
    Z(K)=(FANEW(1)-(1/(1+exp(-Enorm))))*sqrt(DMA/L);
    FANEW(1)=1/(1+exp(-Enorm));
    FBNEW(1)=1-FANEW(1);
    else
    FANEW(1)=FANEW(1) -(Z(K)*sqrt(DMA/L));
    FBNEW(1)=FBNEW(1) +(Z(K)*sqrt(DMA/L));
    end 
  
%     plot(J,FANEW);
%     pause(0.1);

%    SET UP OLD ARRAYS FOR NEXT ITERATION
%Think about whether this next statement is actually a while 
    for J=(1:L)
        FAOLD(J)=FANEW(J);
        FBOLD(J)=FBNEW(J);
    end
end

for K=1:L
    T(K)=(K-0.5)/L;
    ZCOTT(K)=1/sqrt(3.14159*T(K));
    R(K)=Z(K)/ZCOTT(K);
end

plot(1:L,FANEW,1:L,FBNEW)
figure
plot(Z)
