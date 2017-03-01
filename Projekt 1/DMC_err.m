function err = DMC_err( param )
%DMC_ERR liczy wartosc bledu regulatora dla zadanych parametrow przy D=120

n = 6000; %dlugosc symulacji, skróæ do 3000 w rysunkach do pdfa i wspomnij
          %o tym w sprawku. wyd³u¿ona do usuniêcia oscylacji
          %przy optymalizacji
Yzad(1:n) = 2.2;  %rozne wartosci symulacji w roznych przedzialach
Yzad(21:n) = 2.5; %mozliwe, ze trzeba je zmienic na relatywne od
Yzad(1001:n)=2.4;  %punktu pracy, tj w przedziale y(umin)<yzad<y(umax)
Yzad(1501:n)=1.85; %wtedy nalezy dodac w glownej petli odpowiednio
Yzad(2201:n)=2.25; %odjac/dodac Ypp
Ypp = 2.2; %punkt pracy
Upp = 1.5;
Y(1:n) = Ypp; %inicjalizacje tablic
U(1:n) = Upp;
u = U - Upp;
err = 0;

%odpowiedzi skokowe pobrane z utworzonego wczesniej pliku
s = fscanf(fopen('step_responses.txt', 'r'),'%f', [1 Inf]);
fclose('all');

%parametry regulatora dobrane eksperymentalnie

D=120;
%param(1)=30;
%param(2)=3;
%param(3)=0.8;

%inicjalizacja macierzy dUp
for i=1:D-1
   dup(i)=0;
end

%generacja pozostalych macierzy
M=zeros(param(1),param(2));
for i=1:param(1)
   for j=1:param(2)
      if (i>=j)
         M(i,j)=s(i-j+1);
      end;
   end;
end;

Mp=zeros(param(1),D-1);
for i=1:param(1)
   for j=1:D-1
      if i+j<=D
         Mp(i,j)=s(i+j)-s(j);
      else
         Mp(i,j)=s(D)-s(j);
      end;      
   end;
end;

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow

K=((M'*M+param(3)*eye(param(2)))^-1)*M';
Ku=K(1,:)*Mp;
Ke=sum(K(1,:));

%glowna petla

for i=21:n
   
   Y(i)=symulacja_obiektu5Y(U(i-10), U(i-11), Y(i-1), Y(i-2));
   
   e=Yzad(i)-Y(i); %uchyb
   err = err + e^2;
   %err = err + abs(e);
   
   du=Ke*e-Ku*dup'; %regulator
   
   if du>0.1 %ograniczenia na szybkosc zmiany sygnalu sterowania
       du = 0.1;
   elseif du<-0.1
       du = -0.1;
   end
   
   for n=D-1:-1:2
      dup(n)=dup(n-1);
   end
   dup(1)=du;
   u(i)=u(i-1)+dup(1);
   
   if u(i)>0.5 %ograniczenia na min/max sygnalu sterowania
       u(i) = 0.5;
       dup(1) = u(i)-u(i-1);
   elseif u(i)<-0.5
       u(i) = -0.5;
       dup(1) = u(i)-u(i-1);
   end
   
   
   U(i)=u(i)+Upp; %przesuniecie do punktu pracy
end


end

