function err = PID_err( param )

n = 10000; %dlugosc symulacji, skróæ do 3000 w rysunkach do pdfa i wspomnij
          %o tym w sprawku. wyd³u¿ona do usuniêcia oscylacji
          %przy optymalizacji
Yzad(1:n) = 2.2;  %rozne wartosci symulacji w roznych przedzialach
Yzad(21:n) = 2.5; %mozliwe, ze trzeba je zmienic na relatywne od
Yzad(2001:n)=2.4;  %punktu pracy, tj w przedziale y(umin)<yzad<y(umax)
Yzad(4501:n)=1.85; %wtedy nalezy dodac w glownej petli odpowiednio
Yzad(7201:n)=2.25; %odjac/dodac Ypp
U(1:n) = 1.5; %inicjalizacja sterowania
Ypp = 2.2; %punkt pracy
Upp = 1.5;
Y(1:n) = Ypp; %inicjalizacja wyjscia
u = U - Upp; %inicjalizacja sterowania liczonego w regulatorze
err = 0;

Ts = 0.5; K = param(1); Ti = param(2); Td = param(3);

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

err = sum(e.^2);
%err = sum(abs(e));


end

