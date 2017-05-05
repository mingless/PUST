close all;
clear all;

%trap - parametry trapezoidalnych funkcji przynaleznosci, kolejno a b c d
%(wejscia), latwiej odczytac z wykresu w wierszach. Liczba wierszy - liczba
%oddzielnych regulatorow

%liczba regulatorow
reg = 6;

if reg == 1
    trapu = [-1 -0.9 0.9 1];
    K = 0.179027601957906;
    Ti = 3.704713046081166;
    Td = 1.071891045104810;
elseif reg == 2
    trapu = [-1 -0.9 0.2 0.3;...
            0.2 0.3 0.9 1];

    K = [0.479881301349376 0.124587984682865];
    Ti = [1.381567530175739 4.181803394572416];
    Td = [1.415368606139710 0.874266044528476];
elseif reg == 3
    trapu = [-1 -0.9 0.1 0.2;...
            0.1 0.2 0.5 0.6;...
            0.5 0.6 0.9 1];
    K = [0.706031573083377 0.168500094783676 0.103530967479776];
    Ti = [1.390545880029533 3.086305646175291 4.443456315431565];
    Td = [1.341677508103398 0.992203908947000 0.802408171164555];
elseif reg == 4
    trapu = [-1 -0.9 0 0.1;...
            0 0.1 0.2 0.3;...
            0.2 0.3 0.5 0.6;...
            0.5 0.6 0.9 1];
    K = [1.168688797181049 0.285003598076519 0.157104128914089...
       0.103530967479776];
    Ti = [1.413006053008096 2.430061246473383 3.264464973643415...
        4.443456315431565];
    Td = [1.280936363820794 1.021454295522390 1.162166243563955...
        0.802408171164555];
elseif reg == 5
    trapu = [-1 -0.9 0 0.1;...
            0 0.1 0.15 0.25;...
            0.15 0.25 0.35 0.45;...
            0.35 0.45 0.5 0.6;...
            0.5 0.6 0.9 1];
    K = [1.168688797181049 0.311730038567528 0.180028180156292...
       0.011453979233411 0.103530967479776];
    Ti = [1.413006053008096 2.392883744574091 2.901953866871270...
        0.555888832486690 4.443456315431565];
    Td = [1.280936363820794 0.989670578946960 1.144162938580501...
        0.023282995886553 0.802408171164555];
elseif reg == 6
    trapu = [-1 -0.9 0 0.05;...
            0 0.05 0.10 0.15;...
            0.10 0.15 0.20 0.25;...
            0.20 0.25 0.35 0.45;...
            0.35 0.45 0.5 0.6;...
            0.5 0.6 0.9 1];
    K = [1.161170971332974 0.389927496920352 0.255627453476433...
        0.180028180156292 0.011453979233411 0.103530967479776];
    Td = [1.299538092250078 0.986176293374924 1.015067331665758...
        1.144162938580501 0.023282995886553 0.802408171164555];
    Ti = [1.387439164442413 2.292886229628617 2.494709805217276...
        2.901953866871270 0.555888832486690 4.443456315431565];
end

trapy = arrayfun(@stat_val,trapu); %przypisanie konkretnych granic Y
trapy(1,1:2)=-inf; %rozszerzenie granic koncowych do nieskonczonosci
trapy(end,3:4)=inf;



%odkomentowac aby otrzymac K,Ti,Td nowego regulatora. Nie dziala do konca
%poprawnie przy granicy prawej trapu = 1, nalezy je ustawic na 0.9 przy
%wyznaczaniu parametrow

% for i = 1:size(trapu,1)
%     [K(i), Ti(i), Td(i)] = pid_params(trapu(i,2),stat_val(trapu(i,2)),...
%                                       stat_val(trapu(i,3)));
% end


n = 1000;
Yzad(1:n) = 0;
Yzad(21:n) = 7;
Yzad(201:n)= -0.2;
Yzad(401:n)= 2;
Yzad(601:n)=4.2;
Yzad(801:n)=0.5;
U(1:n) = 0;
Y(1:n) = 0;
err = 0;

Ts(1:size(trapu,1)) = 0.5;


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);
mi = zeros(1,size(trapu,1)); %init wspolczynnikow przynaleznosci

%glowna petla PID
for k=21:n
     Y(k)=symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
     e(k)=Yzad(k)-Y(k); %blad wyjscia

     for i = 1:size(trapu,1)
        mi(i) = trapmf(Y(k),trapy(i,:)); %przynaleznosc aktualnego Y(k)
     end
     du = sum(mi.*(r2*e(k-2)+r1*e(k-1)+r0*e(k)));

     U(k)=du+U(k-1);
     if U(k)>1 %ograniczenia na min/max sygnalu sterowania
         U(k) = 1;
     end
     if U(k)<-1
         U(k) = -1;
     end
end;

err = sum(e.^2)

figure('Position',  [403 246 820 420]);
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

%funkcja zwracajaca wartosc y charakterystyki statycznej dla zadanego u
function y = stat_val(u)
    load stat.mat
    if (u>=-1 && u<=1)
        y = Ys( int8((u+1)*50 + 1) );
    end
end
