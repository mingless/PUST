clear all;

%cos dziala, ale y1 sie dziwnie zachowuje
%dziwne - odbicie S w poziomie nie wplywa na nic. Idk czy tak powinno byc

%okropne indeksowania wynikacja z zawarcia wektorow w macierzach
%prawdopodbnie mozna to uproscic korzystajac z cell, ale to komplikuje
%obliczenia

load('step_responses.mat');
% S = zeros(1,1,190)
% S(1,1,:) = fscanf(fopen('input_step_response.txt', 'r'),'%f', [1 Inf]);
% fclose('all');

nu = length(S(1,:,1));
ny = length(S(:,1,1));
% S = flip(S,1);
% S = flip(S,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%trajektorie zadane i parametry - do ustawienia

n = 300; 

D=100; 
N=100; Nu=100; lambda=1;

Yzad(1:n*ny,1) = 0; %init

%format Yzad: Yzad(NY+K*ny:n*ny) = YS
%gdzie NY - numer wyjscia, K - czas skoku, YS - wartosc skoku

Yzad(1+20*ny:ny:n*ny) = 1.4; %dla dwoch wyjsc - nieparzyste Yzad to
Yzad(1+1000*ny:ny:n*ny)= 0.2;  %Y1zad, parzyste to Y2zad - przypisuje
Yzad(1+1500*ny:ny:n*ny)= -0.8; % tutaj do konkretnych

 Yzad(2+20*ny:ny:n*ny) = 1.4; 
 Yzad(2+150*ny:ny:n*ny)= 0.2;  
 Yzad(2+1200*ny:ny:n*ny)= -0.8; 

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y(1:n*ny,1) = 0; %inicjalizacje tablic
U(1:n*nu,1) = 0;
err = 0;

%inicjalizacja macierzy dUp


dup(1:(D-1)*nu,1)=0;

%generacja macierzy

M = zeros(N*ny,Nu*nu);

for i=1:N
   for j=1:Nu
      if (i>=j)
         M(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i-j+1);
      end; %znajduje miejsce na odpowiednie S_n (bedace macierza) i je wpisuje
   end;
end;

Mp=zeros(N*ny,(D-1)*nu);
for i=1:N
   for j=1:D-1
      if i+j<=D
         Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i+j)-S(1:ny,1:nu,j);
      else
         Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,D)-S(1:ny,1:nu,j);
      end; %analogicznie do macierzy M
   end;
end;

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow

K=((M'*M+lambda*eye(Nu*nu))^-1)*M';
Ku=K(1:nu,:)*Mp; %pierwsze dwa rzedy K * Mp
Ke(1:nu,1) = sum(K(1:nu,:),2); %oddzielnie zsumowane pierwsze nu wierszy macierzy K

%glowna petla

for i=21:n
   %zamiana indeksowania: Y_N(i-K)=>Y(N+(i-K-1)*ny); U_N(i-K)=>Y(N+(i-K-1)*nu); 
   Y(1+(i-1)*ny) = symulacja_obiektu4y1(U(1+(i-7)*nu), U(1+(i-8)*nu), U(2+(i-3)*nu), U(2+(i-4)*nu), Y(1+(i-2)*ny), Y(1+(i-3)*ny));
   Y(2+(i-1)*ny) = symulacja_obiektu4y2(U(1+(i-3)*nu), U(1+(i-4)*nu), U(2+(i-4)*nu), U(2+(i-5)*nu), Y(2+(i-2)*ny), Y(2+(i-3)*ny));
   e=Yzad(1+(i-1)*ny:i*ny)-Y(1+(i-1)*ny:i*ny); %uchyb
   err = err + sum(e.^2);
   
   du=Ke.*e-Ku*dup; %regulator
   
   
   for ni=D-1:-1:2 %przesuniecie
      dup(1+(ni-1)*nu:ni*nu)=dup(1+(ni-2)*nu:(ni-1)*nu);
      
   end
   dup(1:nu)=du;
   
   U(1+(i-1)*nu:i*nu)=U(1+(i-2)*nu:(i-1)*nu)+dup(1:nu);
   
   
   
   
end

err


figure('Position',  [403 0 620 725]);
subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
stairs(U(2:nu:n*nu));
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u_2');
subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
stairs(U(1:nu:n*nu));
decimal_comma(gca, 'XY');
ylabel('u_1');
subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
plot(Y(2:ny:n*ny));
hold on;
plot(Yzad(2:ny:n*ny),':');
decimal_comma(gca, 'XY');
ylabel('y_2');
subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
plot(Y(1:ny:n*ny));
hold on;
plot(Yzad(1:ny:n*ny),':');
decimal_comma(gca, 'XY');
ylabel('y_1');

