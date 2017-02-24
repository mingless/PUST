close all;
clear all;

n = 1000;
Yzad(1:n) = 2.2;
Yzad(20:n) = 2.5;
Yzad(400:n)=2.4;
Yzad(500:n)=1.85;
Yzad(900:n)=2.25;
U(1:n) = 1.5;
Ypp = 2.2;
Upp = 1.5;
Y(1:n) = Ypp;
u = U - Upp;



%K = 4; Ti = inf; Td = 0; Ts = 0.5;
K = 2.64; Ti = 14; Td = 3.36; Ts = 0.5;
r2 = K*Td/Ts; r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1); r0 = K*(1+Ts/(2*Ti) + Td/Ts);

for k=21:n 
     Y(k)=symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2)); 

     e(k)=Yzad(k)-Y(k); 
     
     du = r2*e(k-2)+r1*e(k-1)+r0*e(k);
     if du>0.1
         du = 0.1;
     end
     if du<-0.1
         du = -0.1;
     end
     u(k)=du+u(k-1); 
     U(k)= u(k) + Upp;
end; 

figure;
title('obiekt z regulatorem PID');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);ylabel('y'); hold on; stairs(Yzad,':');
