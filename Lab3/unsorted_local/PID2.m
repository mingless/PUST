close all;
clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM4 % initialise com port

n = 1000;

Yzad(1:2,1:n)=0;
Yzad(1,21:end)=1.4;
Yzad(1,601:end)=0.2;
Yzad(1,1001:end)=-0.8;
Yzad(2,151:end)=-0.3;
Yzad(2,401:end)=0.9;
Yzad(2,801:end)=-0.7;

U(1:2,1:n)=0;
Y(1:2,1:n)=0;

err = 0;

%przy reg1: oscylacje krytyczne przy K1=2.2, Tk1=20;
%przy reg2: oscylacje krytyczne przy K2=6.9, Tk2=10;
%po zamianie we/wy
%przy reg1: oscylacje krytyczne przy K1=4.6, Tk1=5;
%przy reg2: oscylacje krytyczne przy K2=11.9, Tk2=5;
%Z-N nie dzialal (?)

%Eksperymentalnie


% K(1)=1.1; Ti(1)=9; Td(1)=0.8; Ts(1)=0.5;
% K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
% K(2)=3.45; Ti(2)=9; Td(2)=0.3; Ts(2)=0.5;
% K(2)=0; Ti(2)=inf; Td(2)=0; Ts(2)=0.5;
% K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
% K(2)=4.45; Ti(2)=6; Td(2)=0.1; Ts(2)=0.5;
% K(1)=0.3; Ti(1)=1; Td(1)=0.5; Ts(1)=0.5;

% Parametry z Lab1: K=7.19; Ti=102.8612; Td=0; Ts=1;%
%parametry dobrane z fmincon(@PID_err,[1.1 9 0.8 3.45 9 0.3],[],[],[],[],[0 0 0 0 0 0],[])
K(1)=1.1576; Ti(1)=12.5191; Td(1)=1.4089; Ts(1)=0.5;
K(2)=0.8789; Ti(2)=7.9788; Td(2)=0.5366; Ts(2)=0.5;
e(1:2,1:n)=0;

K=K'; Ti=Ti'; Td=Td'; Ts=Ts';


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);


%glowna petla PID
for k=3:n
     measurements = readMeasurements(1:7);
     Y(1,k)=measurements(1);
     Y(2,k)=measurements(1);

     e(:,k)=Yzad(:,k)-Y(:,k); %blad wyjscia

     du = r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k);

     %du = du([2 1]); %obrocenie konfiguracji regulatora

     U(:,k)=du(:)+U(:,k-1);

     if U(1,k)>100
         U(1,k) = 100;
     end
     if U(1,k)<0
         U(1,k) = 0;
     end
     if U(2,k)>100
         U(2,k) = 100;
     end
     if U(2,k)<0
         U(2,k) = 0;
     end
     %% sending new values of control signals
     disp([measurements(1), U(:,k), Y(:,k), Yzad(:,k)]); % process measurements

     sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50, 0, 0, 0, U(1,k), U(2,k)]);  % new corresponding control values
     %% synchronising with the control process
     waitForNewIteration(); % wait for new batch of measurements to be ready
end;

err = trace(e'*e) %blad funkcji

    if exist('YoldPID.mat','file')
        load('YoldPID.mat');
    end
    figure('Position',  [403 0 620 725]);
    subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
    stairs(U(2,:));
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
    stairs(U(1,:));
    % ylim([-5 5]);
    decimal_comma(gca, 'XY');
    ylabel('u_1');
    subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
    ff = plot(Y(2,:));
    hold on;
    plot(Yzad(2,:),':');
    decimal_comma(gca, 'XY');
    ylabel('y_2');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    ff = plot(Y(1,:));
    hold on;
    plot(Yzad(1,:),':');
    decimal_comma(gca, 'XY');
    ylabel('y_1');
