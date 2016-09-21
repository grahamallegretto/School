function dydt = chargeFunc( t, y, Ct_t, Ct, Cb, R, Qb, Qt )
%CHARGEFUNC Summary of this function goes here
%   Detailed explanation goes here

Ct = interp1(Ct_t',Ct,t);    % Interpolation the data set (Ct_t,Ct) at t

dydt = (1/R)*( ((Qb-y)/Cb) - ((Qt+y)/Ct) ); 

end

