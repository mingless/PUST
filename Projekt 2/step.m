clear all;
close all;

n = 200;        % długość symulacji
U(1:n) = 0;   % wejscie
Y(1:n) = 0;  % wyjscie
Z(1:n) = 0;    % zaklocenie

% sprawdzenie odpowiedzi w punkcie pracy
for k = 7:n
    Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
end

figure;
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylim([1 2]);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
decimal_comma(gca, 'XY');
ylabel('y');


    
    
% skok o 0.5 w chwili k=20
U(20:n) = 2;
for k = 7:n
    Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
end

figure;
title('skok o 0.5 w chwili k=20');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
decimal_comma(gca, 'XY');
ylabel('y');

% odpowiedź skokowa z zad 2 do zad 3

for k = 21:n
    s(k-20) = (Y(k))/0.5;
end

figure;
title('odpowiedź skokowa obiektu');
stairs(s);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('s');

% charakterystyka statyczna do zad 2
 
for i = 1:101
    Us(i) = 0 - 0.5 + (i-1)*(1/100);
    U(1:20) = 0;
    U(20:n) = Us(i);
    for k = 7:n
         Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
    end
    Ys(i) = Y(n);
end
figure;
plot(Us, Ys);
decimal_comma(gca, 'XY');
xlabel('u');
ylabel('y');


figure;

%plotting multiple responses for Z2

for i = 0:5
    skok = 2 - i*0.2;
    U(20:n) = skok;
    for k = 7:n
         Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
    end
    %stairs(Y);
    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(U);
    xlabel('k');
    ylabel('u');
    decimal_comma(gca, 'XY');
    hold on;
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Y);
    ylabel('y');
    decimal_comma(gca, 'XY');
    hold on;
end
legend({'U_s=2','U_s=1,8','U_s=1,6','U_s=1,4','U_s=1,2','U_s=1'}, 'FontSize',7.5);
    
figure;
for i = 0:5
    skok = 2 - i*0.2;
    Z(20:n) = skok;
    for k = 7:n
         Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
    end
    %stairs(Y);
    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(Z);
    xlabel('k');
    ylabel('z');
    decimal_comma(gca, 'XY');
    hold on;
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Y);
    ylabel('y');
    decimal_comma(gca, 'XY');
    hold on;
end
legend({'Z_s=2','Z_s=1,8','Z_s=1,6','Z_s=1,4','Z_s=1,2','Z_s=1'}, 'FontSize',7.5);
    

%close all;