close all;
clear all;


Ypp=32.31;
Upp=30;
n = 560;
% Yzad(1:n) = 1.9;
% Yzad(21:n) = 1.6;
% Yzad(1001:n)=1.4;
% Yzad(1501:n)=2.5;
% Yzad(2201:n)=1.4;
Yzad(1:40)=Ypp;
Yzad(41:340)=40;
Yzad(341:n)=35;

% Y(1:n) = Ypp;
% u(1:n) = Upp;
Y(1:n) = 0;
u(1:n) = 0; %model powstal po przesunieciu do p. (0,0)
err = 0;

K=7.19; Ti=102.8612; Td=0; Ts=1;%
delay = 26;

Yzad = Yzad - Ypp;
r2 = K*Td/Ts; r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1); r0 = K*(1+Ts/(2*Ti) + Td/Ts);
b = [0.003064652225950;2.062569671907917e-13;0.989242651227519;0]

%glowna petla PID
for k=31:n 
     Y(k)=[u(k-delay-1) u(k-delay-2) Y(k-1) Y(k-2)] * b;
     e(k)=Yzad(k)-Y(k); %blad wyjscia
     
     du = r2*e(k-2)+r1*e(k-1)+r0*e(k);

     u(k)=du+u(k-1); 
      if u(k)>100-Upp %ograniczenia na min/max sygnalu sterowania
          u(k) = 100-Upp;
      end
      if u(k)<0-Upp
          u(k) = 0-Upp;
      end
     U(k)= u(k); %przesuniecie sterowania do punktu pracy
     
end; 

err = sum(e.^2)

figure('Position',  [403 246 660 420]);
%title('PID z parametrami eksperymentalnymi, err=19.68');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U+Upp);
ylabel('u'); 
xlabel('k');
 decimal_comma(gca, 'XY');
subplot('Position', [0.1 0.37 0.8 0.6]);
plot(Y+Ypp);
ylabel('y'); 
hold on; 
stairs(Yzad+Ypp,':');
 decimal_comma(gca, 'XY');
