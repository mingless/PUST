close all;
clear all;

n = 3000; %dlugosc symulacji, skróæ do 3000 w rysunkach do pdfa i wspomnij
          %o tym w sprawku. wyd³u¿ona do usuniêcia oscylacji
          %przy optymalizacji
Yzad(1:n) = 2.2;  %rozne wartosci symulacji w roznych przedzialach
Yzad(21:n) = 2.5; %mozliwe, ze trzeba je zmienic na relatywne od
Yzad(1001:n)=2.4;  %punktu pracy, tj w przedziale y(umin)<yzad<y(umax)
Yzad(1501:n)=1.85; %wtedy nalezy dodac w glownej petli odpowiednio
Yzad(2201:n)=2.25; %odjac/dodac Ypp
U(1:n) = 1.5; %inicjalizacja sterowania
Ypp = 2.2; %punkt pracy
Upp = 1.5;
Y(1:n) = Ypp; %inicjalizacja wyjscia
u = U - Upp; %inicjalizacja sterowania liczonego w regulatorze
err = 0;


%K = 4; Ti = inf; Td = 0; Ts = 0.5;
%K = 2.64; Ti = 14; Td = 3.36; Ts = 0.5; %eksperymentalnie dobrane wspolczynniki, Ts z zadania, err = 19.6632
%K = 52.7065; Ti = 8.8554; Td = 2.9005; Ts = 0.5; %przy optymalizacji bledu
%K = 5.036; Ti = 2.882; Td = 3.2845; Ts = 0.5;
%K = 1.0969; Ti = 1.3559; Td = 0.5757; Ts = 0.5;
%K=4.552003; Ti=10.038189; Td=3.660702; Ts = 0.5;
%K=4.551979; Ti=10.038185; Td=3.660651; Ts=0.5; %final w/ err=sum(|e|) as quality index
%K=5.903638; Ti=7.615168; Td=4.223055; Ts=0.5; %n=6000
%K=5.513605; Ti=6.977240; Td=5.106577; Ts=0.5; %yzad as in this file, n=10000
K=5.422910; Ti=8.551461; Td=3.914535; Ts=0.5; %calculated w/ delays
%                               in yzad, look at PID_err. probably not  
%  err=16.7418                  really optimal anymore, but seems to
%                               finally stabilize, though still not cleanly

%it doesn't seem like it's gonna get any prettier with optimization for
%this error function




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

err = sum(e.^2)

figure;
%title('PID z parametrami eksperymentalnymi, err=19.68');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); 
xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
ylabel('y'); 
hold on; 
stairs(Yzad,':');
