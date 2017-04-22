close all;
clear all;

ustart = -0.8;
ymin = -0.1963;
ymax = 0.4242;
 [K, Ti, Td] = pid_params(ustart,ymin,0.4242);

n = 1000;
Yzad(1:n) = ymin;  
Yzad(21:n) = ymax; 
Yzad(501:n)=(ymax+ymin)/2;  
U(1:n) = ustart; 
Y(1:n) = ymin; 
err = 0;

Ts = 0.5; %K = 1.8; Ti = inf; Td = 0;

r2 = K*Td/Ts; r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1); r0 = K*(1+Ts/(2*Ti) + Td/Ts);

%glowna petla PID
for k=21:n 
     Y(k)=symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2)); 
     e(k)=Yzad(k)-Y(k); %blad wyjscia
     
     du = r2*e(k-2)+r1*e(k-1)+r0*e(k);
     
     U(k)=du+U(k-1); 
     if U(k)>1 %ograniczenia na min/max sygnalu sterowania
         U(k) = 1;
     end
     if U(k)<-1
         U(k) = -1;
     end
end; 

err = sum(e.^2);
% err = sum(abs(e));


figure('Position',  [403 246 820 420]);
%title('PID z parametrami eksperymentalnymi, err=19.68');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); 
xlabel('k');
decimal_comma(gca, 'XY');
subplot('Position', [0.1 0.37 0.8 0.6]);
plot(Y);
ylabel('y'); 
hold on; 
stairs(Yzad,':');
decimal_comma(gca, 'XY');
