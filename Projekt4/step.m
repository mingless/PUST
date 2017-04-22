clear all;
close all;

n = 200;        % długość symulacji
U(1:n) = 0;   % zaczynamy z U punktu pracy
Y(1:11) = 0;  % Y punktu pracy
Y(12:n) = 0;    % dla wygody zerujemy wstępnie dalsze wyjścia

% sprawdzenie odpowiedzi w punkcie pracy
for k = 12:n
    Y(k) = symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
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


    
    
% skok o 1 w chwili k=20
U(20:n) = 1;
for k = 12:n
    Y(k) = symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
end

figure;
title('skok o 1 w chwili k=20');
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
    s(k-20) = Y(k);
end

figure;
title('odpowiedź skokowa obiektu');
stairs(s);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('s');

% charakterystyka statyczna do zad 2
 
for i = 1:101
    Us(i) = -1 + (i-1)*(2/100);
    U(1:20) = 0;
    U(20:n) = Us(i);
    for k = 12:n
        Y(k) = symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
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
    skok = 1 - i*0.4;
    U(20:n) = skok;
    for k = 12:n
        Y(k) = symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
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
legend({'U_s=1','U_s=0,6','U_s=0,2','U_s=-0,2','U_s=-0,6','U_s=-1'}, 'FontSize',7.5);
    

%close all;