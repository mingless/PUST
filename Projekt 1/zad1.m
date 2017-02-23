clear all;
close all;

n = 500;
U(1:n) = 1.5;
Y(1:11) = 2.2;
Y(12:n) = 0;

Ys = symulacja_obiektu5Y(1.5, 1.5, 2.2, 2.2);

for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end

% skok o 0.5 w chwili k=15
U(15:n) = 2;
for k = 12:n
    Y(k) = symulacja_obiektu5Y(U(k-10), U(k-11), Y(k-1), Y(k-2));
end
figure;
plot(1:n, Y);
figure;
plot(1:n, U);