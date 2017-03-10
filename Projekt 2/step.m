clear all;
close all;

n = 200;        % dlugosc symulacji
U(1:n) = 0;   % wejscie
Y(1:n) = 0;  % wyjscie
Z(1:n) = 0;    % zaklocenie

% sprawdzenie odpowiedzi w punkcie pracy
for k = 7:n
    Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
end

%wykresy
figure('Position',  [403 146 560 525]); 
subplot('Position', [0.1 0.095 0.8 0.118]);
stairs(U);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u');
subplot('Position', [0.1 0.295 0.8 0.118]);
stairs(Z);
decimal_comma(gca, 'XY');
ylabel('z');
subplot('Position', [0.1 0.495 0.8 0.48]);
stairs(Y);
decimal_comma(gca, 'XY');
ylabel('y');


U(1:n) = 0; %zerowanie dla pewnosci
Y(1:n) = 0;
Z(1:n) = 0;
    
% skok jednostkowy wejúcia w chwili k=10
U(10:n) = 1;
for k = 7:n
    Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
end
%zad 3 odpowiedz dla skoku wejscia
s(1:n-10)=Y(11:n);

%skok jednostkowy zaklocenia w chwili k=10
U(10:n) = 0;
Y(1:n) = 0;
Z(10:n) = 1; 
for k = 7:n
    Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
end
%zad 3 odpowiedz dla skoku zaklocen
sz(1:n-10)=Y(11:n);

figure;
title('odpowiedü dla skoku wejúcia obiektu');
stairs(s);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('s');

figure;
title('odpowiedü dla skoku zak≥Ûcenia obiektu');
stairs(sz);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('s^z');

% charakterystyka statyczna do zad 2, 3D
Us(1:41) = 0;
Zs(1:41) = 0;
Ys(1:41,1:41) = 0;
for i = 1:41
    Us(i) = 0 - 0.5 + (i-1)*(1/40);
    for j = 1:41
        Zs(j) = 0 - 0.5 + (j-1)*(1/40);
        U(1:10) = 0;
        U(10:n) = Us(i);
        Z(10:n) = Zs(j);
        for k = 7:n
             Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
        end
        Ys(i,j) = Y(n);
    end
end
figure;
surf(Us, Zs, Ys);
decimal_comma(gca, 'XY');
xlabel('u');
ylabel('y');
colorbar;
xlabel('U_s');
ylabel('Z_s');
zlabel('Y_s');




Z(1:n) = 0;
U(1:n) = 0;
figure('Position',  [403 146 560 525]);

%kilka odpowiedzi dla Z2, najpierw skoki U

for i = 0:5
    skok = 0.5 - i*0.2;
    U(10:n) = skok;
    for k = 7:n
         Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
    end
    %stairs(Y);
    subplot('Position', [0.1 0.095 0.8 0.118]);
    stairs(U);
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u');
    hold on;
    subplot('Position', [0.1 0.295 0.8 0.118]);
    stairs(Z);
    decimal_comma(gca, 'XY');
    ylabel('z');
    hold on;
    subplot('Position', [0.1 0.495 0.8 0.48]);
    plot(Y);
    decimal_comma(gca, 'XY');
    ylabel('y');
    hold on;
end
legend({'U_s=0,5','U_s=0,3','U_s=0,1','U_s=-0,1','U_s=-0,3','U_s=-0,5'}, 'FontSize',8);
Z(1:n) = 0;
U(1:n) = 0;


%skoki Z
figure('Position',  [403 146 560 525]);
for i = 0:5
    skok = 0.5 - i*0.2;
    Z(10:n) = skok;
    for k = 7:n
         Y(k) = symulacja_obiektu2y(U(k-5), U(k-6), Z(k-3), Z(k-4), Y(k-1), Y(k-2));
    end
    %stairs(Y);
    
    subplot('Position', [0.1 0.095 0.8 0.118]);
    stairs(U);
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u');
    hold on;
    subplot('Position', [0.1 0.295 0.8 0.118]);
    stairs(Z);
    decimal_comma(gca, 'XY');
    ylabel('z');
    hold on;
    subplot('Position', [0.1 0.495 0.8 0.48]);
    plot(Y);
    decimal_comma(gca, 'XY');
    ylabel('y');
    hold on;
end
legend({'Z_s=0,5','Z_s=0,3','Z_s=0,1','Z_s=-0,1','Z_s=-0,3','Z_s=-0,5'}, 'FontSize',8);
    

%close all;