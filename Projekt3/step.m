clear all;
close all;

n = 200;        % długość symulacji
U1(1:n) = 0;   % zaczynamy z U punktu pracy
U2(1:n) = 0;   % zaczynamy z U punktu pracy
Y1(1:n) = 0;  % Y punktu pracy
Y2(1:n) = 0;

% sprawdzenie odpowiedzi w punkcie pracy
for k = 12:n
    Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
    Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
end

figure('Position',  [403 0 620 725]);
subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
stairs(U2);
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('u_2');
subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
stairs(U1);
decimal_comma(gca, 'XY');
ylabel('u_1');
subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
plot(Y2);
decimal_comma(gca, 'XY');
ylabel('y_2');
subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
plot(Y1);
decimal_comma(gca, 'XY');
ylabel('y_1');

%odpowiedzi do Z2
%skok u1
U1(1:n) = 0;
U2(1:n) = 0;
Y1(1:n) = 0;
Y2(1:n) = 0;
figure('Position',  [403 0 620 725]);
for i = 0:5
    skok = 2 - i*0.8;
    U1(20:n) = skok;
    for k = 12:n
            Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
            Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
    end
    %stairs(Y);
    subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
    stairs(U2);
    decimal_comma(gca, 'XY');
    hold on;
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
    stairs(U1);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('u_1');
    subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
    plot(Y2);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('y_2');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    plot(Y1);
    set(gca,'YTick',-5:2.5:5);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('y_1');
end
legend({'U_{1s}=2','U_{1s}=1,2','U_{1s}=0,4','U_{1s}=-0,4','U_{1s}=-1,2','U_{1s}=-2'}, 'FontSize',8);

%skok u2
U1(1:n) = 0;
U2(1:n) = 0;
Y1(1:n) = 0;
Y2(1:n) = 0;
figure('Position',  [403 0 620 725]);
for i = 0:5
    skok = 2 - i*0.8;
    U2(20:n) = skok;
    for k = 12:n
            Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
            Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
    end
    %stairs(Y);
    subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
    stairs(U2);
    decimal_comma(gca, 'XY');
    hold on;
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
    stairs(U1);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('u_1');
    subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
    plot(Y2);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('y_2');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    plot(Y1);
    decimal_comma(gca, 'XY');
    hold on;
    ylabel('y_1');
end
legend({'U_{2s}=2','U_{2s}=1,2','U_{2s}=0,4','U_{2s}=-0,4','U_{2s}=-1,2','U_{2s}=-2'}, 'FontSize',8);
    
n=200;

% skok jednostkowy u1 w chwili k=20
U1(1:n) = 0;
U2(1:n) = 0;
Y1(1:n) = 0;
Y2(1:n) = 0;
S=zeros(2,2,n-20);


U1(20:n) = 1;
for k = 21:n
    Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
    Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
end

S(1,1,:)=Y1(21:n);
S(2,1,:)=Y2(21:n);

U1(20:n) = 0;
U2(20:n) = 1;
for k = 21:n
    Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
    Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
end

S(1,2,:)=Y1(21:n);
S(2,2,:)=Y2(21:n);

% odpowiedź skokowa z zad 2 do zad 3


figure('Position',  [403 0 620 620]);
subplot(2,2,1);
stairs(squeeze(S(1,1,:))); %squeeze func removes singleton dimensions
ylabel('s^{11}');
ylim([0 2.5]);
decimal_comma(gca,'XY');
subplot(2,2,2);
stairs(squeeze(S(1,2,:)));
ylabel('s^{12}');
ylim([0 2.5]);
decimal_comma(gca,'XY');
subplot(2,2,3);
stairs(squeeze(S(2,1,:)));
ylabel('s^{21}');
ylim([0 2.5]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(2,2,4);
stairs(squeeze(S(2,2,:)));
ylabel('s^{22}');
ylim([0 2.5]);
xlabel('k');
decimal_comma(gca,'XY');

% charakterystyka statyczna do zad 2
U1s(1:41) = 0;
U2s(1:41) = 0;
Y1s(1:41,1:41) = 0;
Y2s(1:41,1:41) = 0;
for i = 1:41
    U1s(i) = 0 - 0.5 + (i-1)*(1/40);
    for j = 1:41
        U2s(j) = 0 - 0.5 + (j-1)*(1/40);
        U1(1:10) = 0;
        U1(10:n) = U1s(i);
        U2(1:10) = 0;
        U2(10:n) = U2s(j);
        for k = 10:n
             Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
             Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
        end
        Y1s(i,j) = Y1(n);
        Y2s(i,j) = Y2(n);
    end
end
figure;
surf(U1s, U2s, Y1s);
decimal_comma(gca, 'XY');
xlabel('U_{1s}');
ylabel('U_{2s}');
zlabel('Y_{1s}');

figure;
surf(U1s, U2s, Y2s);
decimal_comma(gca, 'XY');
xlabel('U_{1s}');
ylabel('U_{2s}');
zlabel('Y_{2s}');





    

%close all;