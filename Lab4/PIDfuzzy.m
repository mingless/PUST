close all;
clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM3 % initialise com port

%trap - parametry trapezoidalnych funkcji przynaleznosci, kolejno a b c d
%(wejscia), latwiej odczytac z wykresu w wierszach. Liczba wierszy - liczba
%oddzielnych regulatorow

%liczba regulatorow
reg = 2;

if reg == 1
    trapu = [-1 -1 1 1];
    K = 0.179027601957906;
    Ti = 3.704713046081166;
    Td = 1.071891045104810;
elseif reg == 2
%     trapu = [-1 -1 0.2 0.3;...
%     0.2 0.3 1 1];

    K = [4.39 9.37];
    Ti = [61.57 57.48];
    Td = [3.28 12.38];
end;

% trapy = arrayfun(@stat_val,trapu); %przypisanie konkretnych granic Y
% trapy(1,1:2)=-inf; %rozszerzenie granic koncowych do nieskonczonosci
% trapy(end,3:4)=inf;

trapy = [-inf -inf 41.18 42.18;...
         41.18 42.18 inf inf];


%odkomentowac aby otrzymac K,Ti,Td nowego regulatora. Nie dziala do konca
%poprawnie przy granicy prawej trapu = 1, nalezy je ustawic na 0.9 przy
%wyznaczaniu parametrow

% for i = 1:size(trapu,1)
%     [K(i), Ti(i), Td(i)] = pid_params(trapu(i,2),stat_val(trapu(i,2)),...
%                                       stat_val(trapu(i,3)));
% end


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

Ts(1:reg) = 1;


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);
mi = zeros(1,reg); %init wspolczynnikow przynaleznosci

sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
[50, 0, 0, 0, 0, 0]);  % new corresponding control values

sendNonlinearControls(U(1));
figure('Position',  [403 246 820 420]);
%glowna petla PID
for k=3:n
    measurements = readMeasurements(1:7);
    Y(k) = measurements(1);

    e(k)=Yzad(k)-Y(k); %blad wyjscia
    err = err + e(k)^2;

    for i = 1:reg
        mi(i) = trapmf(Y(k),trapy(i,:)); %przynaleznosc aktualnego Y(k)
    end
    du = sum(mi.*(r2*e(k-2)+r1*e(k-1)+r0*e(k)));
    
    u(k) = u(k-1) + du;
    
    U(k)=u(k) + Upp;

    if U(k) > 100 %ograniczenia na min/max sygnalu sterowania
        U(k) = 100;
    end
    if U(k) < 0
        U(k) = 0;
    end

    %% sending new values of control signals
    disp([k, U(k), Y(k), Yzad(k), err]); % process measurements

    sendNonlinearControls(U(k));

    %title('PID z parametrami eksperymentalnymi, err=19.68');
    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(U);
    ylabel('u');
    xlabel('k');
    decimal_comma(gca, 'XY');
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Y);
    ylabel('y');
    hold on;
    stairs(Yzad,':');
    decimal_comma(gca, 'XY');
    hold off;
    pause(0.01);
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end;

err = sum(e.^2)


