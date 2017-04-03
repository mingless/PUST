clear all;
close all;

addpath('F:\SerialCommunication');  % add a path to the functions
initSerialControl COM4              % initialise com port

%zdaje sie dzialac poprawnie

%okropne indeksowania wynikacja z zawarcia wektorow w macierzach
%prawdopodbnie mozna to uproscic korzystajac z cell, ale to komplikuje
%i spowalnia obliczenia

load('step_responses.mat');

nu = length(S(1,:,1));
ny = length(S(:,1,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%trajektorie zadane i parametry - do ustawienia

n = 700; %dlugosc symulacji

D=100;      %parametry regulatora
N=100; Nu=100; lambda=1;

U1pp = 30;
U2pp = 35;
Y1pp = 0;
Y2pp = 0;

Yzad(1:n*ny,1) = 0; %init

%format wpisywania Yzad: Yzad(NY+K*ny:ny:n*ny) = YS
%gdzie NY - numer wyjscia, K - czas skoku, YS - wartosc skoku

Yzad(1+20*ny:ny:n*ny) = 1.4;
Yzad(1+1000*ny:ny:n*ny)= 0.2;
Yzad(1+1500*ny:ny:n*ny)= -0.8;

Yzad(2+20*ny:ny:n*ny) = 1.4;
Yzad(2+150*ny:ny:n*ny)= 0.2;
Yzad(2+1200*ny:ny:n*ny)= -0.8;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y(1:n*ny,1) = 0; %inicjalizacje pionowych wektorow
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

%% sending new values of control signals
%            [W1,W2,W3,W4,G1,G2]
sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
             [50,50, 0, 0,U1pp,U2pp]);  % new corresponding control values

figure('Position',  [403 0 620 725]);

for i=1:n
    %% obtaining measurements
    measurements = readMeasurements(1:7); % read measurements from 1 to 7
    Y(1+(i-1)*ny) = measurements(1);
    Y(2+(i-1)*ny) = measurements(3);
    %% processing of the measurements and new control values calculation
    disp([measurements(1:3), i]); % process measurements

    %zamiana indeksowania: Y_N(i-K)=>Y(N+(i-K-1)*ny); U_N(i-K)=>Y(N+(i-K-1)*nu);
    if U(1+(i-1)*nu) > 100
        U(1+(i-1)*nu) = 100;
    end
    if U(2+(i-1)*nu) > 100
        U(2+(i-1)*nu) = 100;
    end
    if U(1+(i-1)*nu) < 0
        U(1+(i-1)*nu) = 0;
    end
    if U(2+(i-1)*nu) < 0
        U(2+(i-1)*nu) = 0;
    end


    %% sending new values of control signals
    %            [W1,W2,W3,W4,G1,G2]
    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                 [50,50, 0, 0,U(1+(i-1)*nu),U2(2+(i-1)*nu)]);  % new corresponding control values

    e=Yzad(1+(i-1)*ny:i*ny)-Y(1+(i-1)*ny:i*ny); %uchyb
    err = err + sum(e.^2);

    du=Ke*e-Ku*dup; %regulator


    for ni=D-1:-1:2 %przesuniecie dup
        dup(1+(ni-1)*nu:ni*nu)=dup(1+(ni-2)*nu:(ni-1)*nu);

    end
    dup(1:nu)=du;

    U(1+(i-1)*nu:i*nu)=U(1+(i-2)*nu:(i-1)*nu)+dup(1:nu); %wyznaczenie nowego sterowania


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
    pause(0.01);

    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end

err

dlmwrite('DMC1_Y1.txt', Y(1:ny:n*ny), ' ');
dlmwrite('DMC1_Y2.txt', Y(2:ny:n*ny), ' ');
dlmwrite('DMC1_U1.txt', U(1:nu:n*nu), ' ');
dlmwrite('DMC1_U2.txt', U(2:nu:n*nu), ' ');
