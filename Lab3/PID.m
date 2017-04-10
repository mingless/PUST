close all;
clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM17 % initialise com port

n = 1000;
U1pp = 30;
U2pp = 35;
Y1pp = 36.18;
Y2pp = 38.12;
Yzad(1,1:n) = Y1pp;
Yzad(2,1:n) = Y2pp;
Yzad(1,50:n) = Y1pp + 3;
Yzad(2,350:n) = Y2pp + 1.5;
Yzad(1,650:n) = Y1pp - 0.5;
% Yzad(1,1:n) = Y1pp;
% Yzad(1,100:n) = Y1pp + 1;
% Yzad(2,1:n) = Y2pp;

Y(1,1:n)= Y1pp;
Y(2,1:n)= Y2pp;
U(1:2,1:n)= 0;

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
K(1)=10; Ti(1)=45; Td(1)=15; Ts(1)=1;
K(2)=10; Ti(2)=45; Td(2)=15; Ts(2)=1;
e(1:2,1:n)=0;

K=K'; Ti=Ti'; Td=Td'; Ts=Ts';


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);

sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
             [50, 50, 0, 0, U1pp, U2pp]);  % new corresponding control values

figure('Position',  [403 0 620 725]);

%glowna petla PID
for k=3:n
     measurements = readMeasurements(1:7);
     Y(1,k)=measurements(1);
     Y(2,k)=measurements(3);

     e(:,k)=Yzad(:,k)-Y(:,k); %blad wyjscia

     du = r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k);

     %du = du([2 1]); %obrocenie konfiguracji regulatora

     U(:,k)=du(:)+U(:,k-1);
     
     U1 = U(1,k) + U1pp;
     U2 = U(2,k) + U2pp;

     if U1>100
         U1 = 100;
     end
     if U1<0
         U1 = 0;
     end
     if U2>100
         U2 = 100;
     end
     if U2<0
         U2 = 0;
     end
     %% sending new values of control signals
     disp([measurements([1 3]), U1, U2, Y(1,k), Yzad(1,k), Y(2,k), Yzad(2,k)]); % process measurements

     sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50, 50, 0, 0, U1, U2]);  % new corresponding control values
                 
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
    pause(0.01);
    
     %% synchronising with the control process
     waitForNewIteration(); % wait for new batch of measurements to be ready
end;

err = trace(e'*e) %blad funkcji
