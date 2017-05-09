clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM3 % initialise com port

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




% D=300;
% %optimal params
% N=300; Nu=300; lambda=1; %err=15.6111

reg = 2;

%uznajemy ze D = N = Nu dla uproszczenia. mozna dodac recznie inne wartosci


if reg == 2
%     trapu = [-1 -0.9 0.2 0.3;...
%     0.2 0.3 0.9 1];
    D = {300, 250};
    lambda = {0.15, 0.15};
end

N = D;
Nu = D;

% trapy = arrayfun(@stat_val,trapu); %przypisanie konkretnych granic Y
% trapy(1,1:2)=-inf; %rozszerzenie granic koncowych do nieskonczonosci
% trapy(end,3:4)=inf;

trapy = [-inf -inf 41.18 42.18;...
         41.18 42.18 inf inf];

s = cell(1, reg);
%get step response from file
s{1} = fscanf(fopen('DMCs1.txt', 'r'),'%f', [1 Inf]);
s{2} = fscanf(fopen('DMCs2.txt', 'r'),'%f', [1 Inf]);
fclose('all');

% for i = 1:reg
%     s{i} = get_step_resp(trapu(i,2),trapu(i,3)); %zastapic wczytaniem z
% end                                              %pliku na laboratorium



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
    u(k)=u(k-1);
    for i = 1:reg
        du{i}=Ke{i}*e-Ku{i}*dup{i}'; %regulator
        for n=D{i}-1:-1:2
            dup{i}(n)=dup{i}(n-1);
        end
        dup{i}(1)=du{i};
        mi{i} = trapmf(Y(k),trapy(i,:)); %trapezowa funkcja przynaleznosci
        u(k) = u(k) + mi{i}*dup{i}(1);
    end

    U(k) = u(k) + Upp;

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
