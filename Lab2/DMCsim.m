clear all;

%[b1 b2 -a1 -a2] - parametry transmitancji dyskretnej
b = [8.466576777118165e-05;8.039643787921877e-05;...   
     1.854463482611194;-0.856207574969240];             %dla skoku 
delay = 12                                              %zaklocenia



b = [0.003064652225950;2.062569671907917e-13;0.989242651227519;0];
                                                        %dla skoku
delay = 26;                                             %sterowania
            

                %wyznaczone przy pomocy skryptu opt.m z Lab1
                
                
                
                

n = 700;
Ypp = 33.2;
Upp = 30;
Yzad(1:n) = Ypp;
Z(1:n) = 0;
Yzad(51:n) = Ypp + 3;
%Z(201:n) = 25; %zaklocenie skokowe
%Z(451:n) = 10;
% Z(61:n)=sin(linspace(0,10*pi,140)); %zaklocenie sinusoidalne
pomiar = 0;
szum = 0; snr = 0; %signal-to-noise ratio

D=280; Dz=280; %dobrane na podstawie stabilizacji odpowiedzi
% N=120; Nu=20; lambda=1; %err=7.8485
% N=25; Nu=20; lambda=1; %err=7.8482    kolejne kroki dobierania
% N=25; Nu=8; lambda=1; %err=7.7889
N=280; Nu=280; lambda=1; %err=5.9223, eksperymentalnie



Y(1:n) = 0;
U(1:n) = 0;
Yzad = Yzad - Ypp;
err = 0;

%odpowiedzi skokowe pobrane z utworzonego wczesniej pliku
s = fscanf(fopen('sims/step_response.txt', 'r'),'%f', [1 Inf]);
sz = fscanf(fopen('sims/step_response2_fixed.txt', 'r'),'%f', [1 Inf]);
fclose('all');

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
Zpom = Z;
if szum
    Zpom = awgn(Zpom,snr); %dodaje bialy szum gaussowski o zadanym stosunku
                          %sygna³u do szumu (SNR)
end
for i=31:n
   %TODO: ZMIENIC NA MODEL Z ZAKLOCENIEM
   Y(i)=[U(i-delay-1) U(i-delay-2) Y(i-1) Y(i-2)] * b;

   e=Yzad(i)-Y(i); %uchyb
   err = err + e^2;

   du=Ke*e-Ku*dup'; %regulator
   if pomiar %regulator nie bierze pod uwage pomiaru zaklocen gdy pomiar=0
       du = du - Kz*dz';
       for n=Dz:-1:2
            dz(n)=dz(n-1);
       end
       dz(1)=Zpom(i)-Zpom(i-1);
   end

   for n=D-1:-1:2 %przesuniecie macierzy dUp i dZ, dodanie nowej wartosci
      dup(n)=dup(n-1);
   end
   dup(1)=du;
   U(i)=U(i-1)+dup(1);
   
   if U(i)>100+Upp
       U(i) = 100+Upp;
   end
   if U(i)<0-Upp
       U(i) = 0-Upp;
   end
   




end

err

%wykresy
figure('Position',  [403 146 560 525]);
subplot('Position', [0.1 0.095 0.8 0.118]);
stairs(U+Upp);
% decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.295 0.8 0.118]);
plot(Z);
hold on;
plot(Zpom);
% decimal_comma(gca, 'XY');
ylabel('z');
subplot('Position', [0.1 0.495 0.8 0.48]);
plot(Y+Ypp);
% decimal_comma(gca, 'XY');
ylabel('y');
hold on;
stairs(Yzad+Ypp,':');

