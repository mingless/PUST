clear;
close all;
global delay;
fval(1:50) = 0;

Y1pp = 0;
Y2pp = 0;
s1 = fscanf(fopen('G1_step_30_T1.txt', 'r'), '%f', [1 inf]);
s2 = fscanf(fopen('G1_step_30_T3.txt', 'r'), '%f', [1 inf]);

s3 = fscanf(fopen('G2_step_30_T1.txt', 'r'), '%f', [1 inf]);
s4 = fscanf(fopen('G2_step_30_T3.txt', 'r'), '%f', [1 inf]);

s1 = (s1(50:end)-Y1pp)/30;
s2 = (s2(50:end)-Y2pp)/30;

s3 = (s3(50:end)-Y1pp)/30;
s4 = (s4(50:end)-Y2pp)/30;

for it = 12:12
    delay = it;

    [param, fval(it), flag] = fmincon(@approx_err,[0.5 20 25])

    % optymalne param =  [0.284889175853091 6.766718807934197e-11 92.458806630315240]
    % b1 = 0.0031
    % b2 = 2.0626e-13
    % a1 = -0.9892
    % a2 = 0

    % data(1:300) = 0;
    % data(50:300) = 1;
    % Yzad(1:300) = 0;
    % Yzad(50:300) = 0.5;
    % Yzad(100:300) = 1;
    fclose('all');
    data(1:300) = 0;
    data(delay+3:300) = 1;  %Od pewnego momentu zaczynalo brakowac pomiarow
                            %z przeszlosci, zaczelismy wiec przesuwac
                            %lekko aproksymowana funkcje wraz ze skokiem
                            %mozna temu bylo zapobiec biorac od poczatku skok
                            %w znacznie pozniejszej chwili od samego poczatku,
                            %np w k=100. blad uzyskanej metody jednak nie
                            %powinien byc znaczacy.
    Y1(1:300) = s1(50-delay-2:350-delay-3);
    Y2(1:300) = s2(50-delay-2:350-delay-3);

    K = param(1); T1 = param(2); T2 = param(3);
    alp1 = exp(-1/T1);
    alp2 = exp(-1/T2);
    a1 = -alp1 - alp2;
    a2 = alp1*alp2;
    b1 = K/(T1-T2) * (T1 * (1 - alp1) - T2 * (1 -alp2));
    b2 = K/(T1-T2) * (alp1 * T2 * (1 - alp2) - alp2 * T1 * (1 - alp1));
    b = [b1 b2 -a1 -a2]';

    Ymod = modelout(data,b,delay);
    figure;
    plot(Ymod);
    %decimal_comma(gca, 'XY');
    hold on;
    plot(Y1);
    plot(Y2);
    %decimal_comma(gca, 'XY');

    % figure('Position',  [403 246 660 420]);
    figure;
    %title('PID z parametrami eksperymentalnymi, err=19.68');
    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(data);
    ylabel('u');
    xlabel('k');
    % decimal_comma(gca, 'XY');
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Ymod);
    ylabel('y');
    hold on;
    plot(Y1);
    plot(Y2);
    % decimal_comma(gca, 'XY');
end
