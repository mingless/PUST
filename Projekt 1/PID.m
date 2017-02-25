close all;
clear all;

n = 1000; %dlugosc symulacji
Yzad(1:n) = 2.2;  %rozne wartosci symulacji w roznych przedzialach
Yzad(21:n) = 2.5; %mozliwe, ze trzeba je zmienic na relatywne od
Yzad(401:n)=2.4;  %punktu pracy, tj w przedziale y(umin)<yzad<y(umax)
Yzad(501:n)=1.85; %wtedy nalezy dodac w glownej petli odpowiednio
Yzad(901:n)=2.25; %odjac/dodac Ypp
U(1:n) = 1.5; %inicjalizacja sterowania
Ypp = 2.2; %punkt pracy
Upp = 1.5;
Y(1:n) = Ypp; %inicjalizacja wyjscia
u = U - Upp; %inicjalizacja sterowania liczonego w regulatorze



%K = 4; Ti = inf; Td = 0; Ts = 0.5;
K = 2.64; Ti = 14; Td = 3.36; Ts = 0.5; %losowo dobrane wspolczynniki, Ts z zadania
r2 = K*Td/Ts; r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1); r0 = K*(1+Ts/(2*Ti) + Td/Ts);

%glowna petla PID
for k=21:n 
     Y(k)=symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2)); 
     e(k)=Yzad(k)-Y(k); %blad wyjscia
     du = r2*e(k-2)+r1*e(k-1)+r0*e(k);
     if du>0.1 %ograniczenia na szybkosc zmiany sygnalu sterowania
         du = 0.1;
     end
     if du<-0.1
         du = -0.1;
     end
     u(k)=du+u(k-1); 
     if u(k)>0.5 %ograniczenia na min/max sygnalu sterowania
         u(k) = 0.5;
     end
     if u(k)<-0.5
         u(k) = -0.5;
     end
     U(k)= u(k) + Upp; %przesuniecie sterowania do punktu pracy
end; 

figure;
title('obiekt z regulatorem PID');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); 
xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
ylabel('y'); 
hold on; 
stairs(Yzad,':');
