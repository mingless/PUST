clear all;

n = 200; 
Yzad(1:20) = 0;
Yzad(21:n) = 1;
pomiar = 1;


Y(1:n) = 0; %inicjalizacja tablic
U(1:n) = 0;
Z(1:n) = 0;
%  Z(121:n) = 1;
err = 0;

%odpowiedzi skokowe pobrane z utworzonego wczesniej pliku
s = fscanf(fopen('input_step_response.txt', 'r'),'%f', [1 Inf]);
sz = fscanf(fopen('noise_step_response.txt', 'r'),'%f', [1 Inf]);
fclose('all');


D=120; Dz=50;
N=25; Nu=8; lambda=0.05; %err=5.9223

for i=1:D-1
   dup(i)=0;
end

for i=1:Dz
   dz(i)=0;
end
%generacja macierzy

M=zeros(N,Nu);
for i=1:N
   for j=1:Nu
      if (i>=j)
         M(i,j)=s(i-j+1);
      end;
   end;
end;

Mp=zeros(N,D-1);
for i=1:N
   for j=1:D-1
      if i+j<=D
         Mp(i,j)=s(i+j)-s(j);
      else
         Mp(i,j)=s(D)-s(j);
      end;      
   end;
end;

Mz=zeros(N,Dz-1);
for i=1:N
   for j=1:Dz-1
      if i+j<=Dz
         Mz(i,j)=sz(i+j)-sz(j);
      else
         Mz(i,j)=sz(Dz)-sz(j);
      end;      
   end;
end;
Mz = [sz(1:N)' Mz];
%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow

K=((M'*M+lambda*eye(Nu))^-1)*M';
Ku=K(1,:)*Mp;
Kz=K(1,:)*Mz;
Ke=sum(K(1,:));

%glowna petla

for i=11:n
   
   Y(i)=symulacja_obiektu2y(U(i-5), U(i-6), Z(i-3), Z(i-4), Y(i-1), Y(i-2));
   
   e=Yzad(i)-Y(i); %uchyb
   err = err + e^2;
   
   du=Ke*e-Ku*dup'; %regulator
   if pomiar
       du = du - Kz*dz';
   end
%    if du>0.1 %ograniczenia na szybkosc zmiany sygnalu sterowania
%        du = 0.1;
%    elseif du<-0.1
%        du = -0.1;
%    end
   
   for n=D-1:-1:2
      dup(n)=dup(n-1);
   end
   for n=Dz:-1:2
      dz(n)=dz(n-1);
   end
   dup(1)=du;
   dz(1)=Z(i)-Z(i-1);
   U(i)=U(i-1)+dup(1);
   
%    if u(i)>0.5 %ograniczenia na min/max sygnalu sterowania
%        u(i) = 0.5;
%        dup(1) = u(i)-u(i-1);
%    elseif u(i)<-0.5
%        u(i) = -0.5;
%        dup(1) = u(i)-u(i-1);
%    end
   
   
end

err

%wykresy
figure('Position',  [403 146 560 525]);
subplot('Position', [0.1 0.095 0.8 0.118]);
stairs(U);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.295 0.8 0.118]);
stairs(Z);
decimal_comma(gca, 'XY');
ylabel('z');
subplot('Position', [0.1 0.495 0.8 0.48]);
stairs(Y);
decimal_comma(gca, 'XY');
ylabel('y');
hold on;
stairs(Yzad,':');

