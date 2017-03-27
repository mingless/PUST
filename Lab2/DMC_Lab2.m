clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM4 % initialise com port

n = 700;

Ypp = 33.2;
Upp = 30;
Yzad(1:n) = Ypp;
Z(1:n) = 0;
Yzad(51:n) = Ypp + 3;
Z(201:n) = 25; %zaklocenie skokowe
Z(451:n) = 10;
% Z(61:n)=sin(linspace(0,10*pi,140)); %zaklocenie sinusoidalne
pomiar = 1;
szum = 0; snr = 0; %signal-to-noise ratio

D=280; Dz=140; %dobrane na podstawie stabilizacji odpowiedzi
% N=120; Nu=20; lambda=1; %err=7.8485
% N=25; Nu=20; lambda=1; %err=7.8482    kolejne kroki dobierania
% N=25; Nu=8; lambda=1; %err=7.7889
N=280; Nu=280; lambda=1; %err=5.9223, eksperymentalnie



Y(1:n) = Ypp;
U(1:n) = Upp;
u = U - Upp;
err = 0;

%odpowiedzi skokowe pobrane z utworzonego wczesniej pliku
s = fscanf(fopen('step_response.txt', 'r'),'%f', [1 Inf]);
sz = fscanf(fopen('step_response2.txt', 'r'),'%f', [1 Inf]);
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

%% sending new values of control signals
sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
             [50, 0, 0, 0, 0, 0]);  % new corresponding control values

for i=2:n
   %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        Y(i)=measurements(1);
        
   e=Yzad(i)-Y(i); %error
   err = err + e^2;
   
   du=Ke*e-Ku*dup'; %reg
   
   if pomiar %regulator nie bierze pod uwage pomiaru zaklocen gdy pomiar=0
       du = du - Kz*dz';
       for n=Dz:-1:2
            dz(n)=dz(n-1);
       end
       dz(1)=Zpom(i)-Zpom(i-1);
   end
   
   for n=D-1:-1:2
      dup(n)=dup(n-1);
   end
   dup(1)=du;
   u(i)=u(i-1)+dup(1);

   U(i)=u(i)+Upp;
   
     if U(i)>100
         U(i) = 100;
     end
     if U(i)<0
         U(i) = 0;
     end
   
   %% processing of the measurements and new control values calculation
        disp([measurements(1), U(i), measurements(5), i]); % process measurements
  
        sendControlsToG1AndDisturbance(U(i), Z(i));
        
        stairs(Y);
        pause(0.01);
        
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
        
end

err

dlmwrite('DMC_3.txt', Y, ' ');
dlmwrite('DMC_3_U.txt', U, ' ');
dlmwrite('DMC_3_Z.txt', Z, ' ');
dlmwrite('DMC_3_Yzad.txt', Yzad, ' ');

%wykresy
figure('Position',  [403 146 560 525]);
subplot('Position', [0.1 0.095 0.8 0.118]);
stairs(U);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.295 0.8 0.118]);
plot(Z);
hold on;
plot(Zpom);
decimal_comma(gca, 'XY');
ylabel('z');
subplot('Position', [0.1 0.495 0.8 0.48]);
plot(Y);
decimal_comma(gca, 'XY');
ylabel('y');
hold on;
stairs(Yzad,':');

