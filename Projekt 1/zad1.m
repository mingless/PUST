clear all;
close all;

n = 200;
U(1:n) = 1.5;
Y(1:11) = 2.2;
Y(12:n) = 0;

Ys = symulacja_obiektu5Y(1.5, 1.5, 2.2, 2.2);

for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end

figure;
title('1a)');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);ylabel('y');

% skok o 0.5 w chwili k=15
U(20:n) = 2;
for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end

figure;
title('skok o 0.5 w chwili k=20');
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u'); xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);
stairs(Y);ylabel('y');

%zad 3

s = zeros(1,180);
for k = 21:n
    s(k-20) = (Y(k)-2.2)/0.5;
end

figure;
title('odpowiedü skokowa obiektu');
stairs(s);
ylabel('s'); xlabel('k');

%close all;

% Zad 2
 
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