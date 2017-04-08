clear all;
close all;

%zdaje sie dzialac poprawnie

%okropne indeksowania wynikacja z zawarcia wektorow w macierzach
%prawdopodbnie mozna to uproscic korzystajac z cell, ale to komplikuje
%i spowalnia obliczenia

load('step_responses.mat');

nu = length(S(1,:,1));
ny = length(S(:,1,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%trajektorie zadane i parametry - do ustawienia

n = 1200; %dlugosc symulacji

D=100;      %parametry regulatora
N=100; Nu=4; lambda=0.2;

szum = 0; snr = 15; %dodanie szumu pomiarowego
zakl = 1; %dodanie niemierzalne zaklocenie do wyjscia.

Z(1:n*ny,1) = 0; %init
Yzad(1:n*ny,1) = 0;


%format wpisywania Z: Z(NY+K*ny:ny:n*ny) = ZS
%gdzie NY - numer wyjscia, K - czas skoku, ZS - wartosc skoku
Z(1+300*ny:ny:n*ny) = -0.1;
Z(2+700*ny:ny:n*ny) = -0.1;


%format wpisywania Yzad: Yzad(NY+K*ny:ny:n*ny) = YS
%gdzie NY - numer wyjscia, K - czas skoku, YS - wartosc skoku

Yzad(1+20*ny:ny:n*ny) = 1.4; 
Yzad(1+600*ny:ny:n*ny)= 0.2;  
Yzad(1+1000*ny:ny:n*ny)= -0.8; 

Yzad(2+150*ny:ny:n*ny)= -0.3;  
Yzad(2+400*ny:ny:n*ny) = 0.9; 
Yzad(2+800*ny:ny:n*ny)= -0.7; 

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y(1:n*ny,1) = 0; %inicjalizacje pionowych wektorow
Ypom(1:n*ny,1) = 0;
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
      end; %znajduje miejsce na odpowiednie S_n (ny x nu) i je tam wpisuje
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

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow dla
%zmniejszenia wymaganych obliczen

K=((M'*M+lambda*eye(Nu*nu))^-1)*M';
Ku=K(1:nu,:)*Mp; %pierwsze dwa rzedy K * Mp
Ke = zeros(nu,ny);
for j=1:ny %nu wierszy zawierajacych ny sum z K dla poszczegolnych wyjsc
    Ke(:,j)=sum(K(1:nu,j:ny:end),2);
end
    

%glowna petla

for i=21:n
   %zamiana indeksowania: Y_N(i-K)=>Y(N+(i-K-1)*ny); U_N(i-K)=>Y(N+(i-K-1)*nu); 
   Y(1+(i-1)*ny) = symulacja_obiektu4y1(U(1+(i-7)*nu), U(1+(i-8)*nu), U(2+(i-3)*nu), U(2+(i-4)*nu), Y(1+(i-2)*ny), Y(1+(i-3)*ny));
   Y(2+(i-1)*ny) = symulacja_obiektu4y2(U(1+(i-3)*nu), U(1+(i-4)*nu), U(2+(i-4)*nu), U(2+(i-5)*nu), Y(2+(i-2)*ny), Y(2+(i-3)*ny));
   
   if zakl
       Y(1+(i-1)*ny:i*ny) = Y(1+(i-1)*ny:i*ny) + Z(1+(i-1)*ny:i*ny);
   end
   
   if szum  %dodanie szumu
       Ypom(1+(i-1)*ny:i*ny) = awgn(Y(1+(i-1)*ny:i*ny),snr);
   else
       Ypom(1+(i-1)*ny:i*ny) = Y(1+(i-1)*ny:i*ny);
   end
   
   e=Yzad(1+(i-1)*ny:i*ny)-Ypom(1+(i-1)*ny:i*ny); %uchyb
   err = err + sum(e.^2);
   
   du=Ke*e-Ku*dup; %regulator
   
   
   for ni=D-1:-1:2 %przesuniecie dup
      dup(1+(ni-1)*nu:ni*nu)=dup(1+(ni-2)*nu:(ni-1)*nu);
      
   end
   dup(1:nu)=du;
   
   U(1+(i-1)*nu:i*nu)=U(1+(i-2)*nu:(i-1)*nu)+dup(1:nu); %wyznaczenie nowego
                                                        %sterowania
end

err

if ~zakl %plot tylko z U(1,2) i Y(1,2)
    if exist('YoldDMC.mat','file')
        load('YoldDMC.mat');
    end
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
    ff = plot(Y(2:ny:n*ny));
    hold on;
    plot(Yzad(2:ny:n*ny),':');
    if szum && exist('YoldDMC.mat','file')
        plot(YoldDMC(2:ny:n*ny));
%         uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_2');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    ff = plot(Y(1:ny:n*ny));
    hold on;
    plot(Yzad(1:ny:n*ny),':');
    if szum && exist('YoldDMC.mat','file')
        fg = plot(YoldDMC(1:ny:n*ny));
        legend([ff fg],'Z zak³óceniami','Bez zak³óceñ');
%         uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_1');
else %splotuj tez Z(1,2)
    figure('Position',  [403 0 620 935]);
    subplot('Position', [0.1 0.0535 0.8 0.0663]); %62 at 50
    stairs(U(2:nu:n*nu));
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.1658 0.8 0.0663]); %62 at 155
    stairs(U(1:nu:n*nu));
    decimal_comma(gca, 'XY');
    ylabel('u_1');
    subplot('Position', [0.1 0.2781 0.8 0.0663]); %62 at 50
    stairs(Z(2:nu:n*nu));
    decimal_comma(gca, 'XY');
    ylabel('u_2');
    subplot('Position', [0.1 0.3904 0.8 0.0663]); %62 at 155
    stairs(Z(1:nu:n*nu));
    decimal_comma(gca, 'XY');
    ylabel('u_1');
    subplot('Position', [0.1 0.5027 0.8 0.2139]); %200 at 260
    ff = plot(Y(2:ny:n*ny));
    hold on;
    plot(Yzad(2:ny:n*ny),':');
    if szum
        plot(Ypom(2:ny:n*ny));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_2');
    subplot('Position', [0.1 0.7594 0.8 0.2139]); %200 at 500
    ff = plot(Y(1:ny:n*ny));
    hold on;
    plot(Yzad(1:ny:n*ny),':');
    if szum
        plot(Ypom(1:ny:n*ny));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_1');
end
