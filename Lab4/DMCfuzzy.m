clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM17 % initialise com port

n = 1350;
Ypp = 32.9;
Upp = 30;
Yzad(1:n) = Ypp + 0;
Yzad(21:n) = Ypp - 1;
Yzad(151:n) = Ypp + 3;
Yzad(401:n) = Ypp + 9;
Yzad(701:n) = Ypp + 7;
Yzad(901:n) = Ypp + 11;
Yzad(1151:n) = Ypp + 9.5;
U(1:n) = Upp;
Y(1:n) = Ypp;
u = U - Upp;
err = 0;

%get step response from file
s = fscanf(fopen('s.txt', 'r'),'%f', [1 Inf]);
s = s./3;
fclose('all');


D=300;
%optimal params
N=300; Nu=300; lambda=1; %err=15.6111

reg = 1;

%uznajemy ze D = N = Nu dla uproszczenia. mozna dodac recznie inne wartosci

if reg == 1
    trapu = [-1 -0.9 0.9 1];
    D = {50};
    lambda = {800};
elseif reg == 2
    trapu = [-1 -0.9 0.2 0.3;...
    0.2 0.3 0.9 1];
    D = {30, 50};
    lambda = {222, 335};
elseif reg == 3
    trapu = [-1 -0.9 0.1 0.2;...
    0.1 0.2 0.5 0.6;...
    0.5 0.6 0.9 1];
    D = {30, 40, 50};
    lambda = {150, 1800, 65};%dalsze lambdy uzyskane przy fmincon
elseif reg == 4
    trapu = [-1 -0.9 0 0.1;...
    0 0.1 0.2 0.3;...
    0.2 0.3 0.5 0.6;...
    0.5 0.6 0.9 1];
    D = {30, 30, 40, 50};
    lambda = {22.8, 327.5, 6, 20.7};
elseif reg == 5
    trapu = [-1 -0.9 0 0.1;...
    0 0.1 0.15 0.25;...
    0.15 0.25 0.35 0.45;...
    0.35 0.45 0.5 0.6;...
    0.5 0.6 0.9 1];
    D = {30, 30, 40, 40, 50};
    lambda = {0.16, 8100, 4.7, 551, 18.7};
elseif reg == 6
    trapu = [-1 -0.9 0 0.05;...
    0 0.05 0.10 0.15;...
    0.10 0.15 0.20 0.25;...
    0.20 0.25 0.35 0.45;...
    0.35 0.45 0.5 0.6;...
    0.5 0.6 0.9 1];
    D = {30, 30, 30, 40, 40, 50};
    %     lambda = {0.16, 2125, 4.3, 8, 16.9, 609};
    lambda = {0.16 17.7 17840 4.4 555 18.5};
end

N = D;
Nu = D;

trapy = arrayfun(@stat_val,trapu); %przypisanie konkretnych granic Y
trapy(1,1:2)=-inf; %rozszerzenie granic koncowych do nieskonczonosci
trapy(end,3:4)=inf;

s = cell(1, reg);

for i = 1:reg
    s{i} = get_step_resp(trapu(i,2),trapu(i,3)); %zastapic wczytaniem z
end                                              %pliku na laboratorium



% D=120;
% %parametry regulatora dobrane eksperymentalnie
% N=120; Nu=120; lambda=2111; %err=15.6111



dup = cell(1,reg); %oddzielna komorka - oddzielny regulator. reszta
M = cell(1,reg);   %identycznie jak w normalnym dmc
Mp = cell(1,reg);
K = cell(1,reg);
Ku = cell(1,reg);
Ke = cell(1,reg);

for k = 1:reg
    dup{k}(1:D{k}-1) = 0;

    M{k}=zeros(N{k},Nu{k});
    for i=1:N{k}
        for j=1:Nu{k}
            if (i>=j)
                M{k}(i,j)=s{k}(i-j+1);
          end;
      end;
  end;

  Mp{k}=zeros(N{k},D{k}-1);
  for i=1:N{k}
       for j=1:D{k}-1
           if i+j<=D{k}
               Mp{k}(i,j)=s{k}(i+j)-s{k}(j);
          else
              Mp{k}(i,j)=s{k}(D{k})-s{k}(j);
          end;
      end;
  end;

  K{k}=((M{k}'*M{k}+lambda{k}*eye(Nu{k}))^-1)*M{k}';
  Ku{k}=K{k}(1,:)*Mp{k};
  Ke{k}=sum(K{k}(1,:));
end

%generacja macierzy

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow


sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
[50, 0, 0, 0, 0, 0]);  % new corresponding control values

sendNonlinearControls(U(1));
figure('Position',  [403 246 820 420]);

%glowna petla

du = cell(1,reg);

for k=3:n
    %% obtaining measurements
    measurements = readMeasurements(1:7); % read measurements from 1 to 7
    Y(k)=measurements(1);

    e=Yzad(k)-Y(k); %uchyb
    err = err + e^2;
    U(k)=U(k-1);
    for i = 1:reg
        du{i}=Ke{i}*e-Ku{i}*dup{i}'; %regulator
        for n=D{i}-1:-1:2
            dup{i}(n)=dup{i}(n-1);
        end
        dup{i}(1)=du{i};
        mi{i} = trapmf(Y(k),trapy(i,:)); %trapezowa funkcja przynaleznosci
        U(k) = U(k) + mi{i}*dup{i}(1);
   end



   if U(k) >100 %ograniczenia na min/max sygnalu sterowania
       U(k) = 100;
   end
   if U(k) < 0
       U(k) = 0;
   end

   %% processing of the measurements and new control values calculation
   disp([k, U(k), Y(k), Yzad(k), err]); % process measurements

   %% sending new values of control signals
   sendNonlinearControls(U(k));

   subplot('Position', [0.1 0.12 0.8 0.15]);
   stairs(U);
   ylabel('u');
   xlabel('k');
   subplot('Position', [0.1 0.37 0.8 0.6]);
   plot(Y);
   ylabel('y');
   hold on;
   stairs(Yzad,':');
   hold off;
   pause(0.01);
   %% synchronising with the control process
   waitForNewIteration(); % wait for new batch of measurements to be ready

end

err

figure('Position',  [403 246 820 420]);
title('obiekt z regulatorem PID');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u');
xlabel('k');
decimal_comma(gca, 'XY');
subplot('Position', [0.1 0.37 0.8 0.6]);
plot(Y);
ylabel('y');
decimal_comma(gca, 'XY');
hold on;
stairs(Yzad,':');

%funkcja zwracajaca wartosc y charakterystyki statycznej dla zadanego u
function y = stat_val(u)
load stat.mat
if (u>=-1 && u<=1)
        y = Ys( int8((u+1)*50 + 1) );
    end
end
