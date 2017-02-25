clear all;
close all;

n = 200;        % długość symulacji
U(1:n) = 1.5;   % zaczynamy z U punktu pracy
Y(1:11) = 2.2;  % Y punktu pracy
Y(12:n) = 0;    % dla wygody zerujemy wstępnie dalsze wyjścia

% sprawdzenie odpowiedzi w punkcie pracy
for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end

figure;
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
ylabel('y');

% skok o 0.5 w chwili k=20
U(20:n) = 2;
for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end

figure;
title('skok o 0.5 w chwili k=20');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);
ylabel('y');

% odpowiedź skokowa z zad 2 do zad 3

for k = 21:n
    s(k-20) = (Y(k)-2.2)/0.5;
end

figure;
title('odpowiedź skokowa obiektu');
stairs(s);
xlabel('k');
ylabel('s');

% charakterystyka statyczna do zad 2
 
for i = 1:101
    Us(i) = 1.5 - 0.5 + (i-1)*(1/100);
    U(1:14) = 2.2;
    U(15:n) = Us(i);
    for k = 12:n
        Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
    end
    Ys(i) = Y(n);
end
figure;
plot(Us, Ys);

close all;