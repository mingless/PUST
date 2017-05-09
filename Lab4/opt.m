clear;
close all;

global delay;
delay = 26;
fval(1:30)=0;




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
s = fscanf(fopen('G1_step_50_20.txt', 'r'), '%f', [1 inf]);
s = (s-41.56)/20;
fclose('all');

%WYNIKI
%step 10: param = 0.4105    4.6605   69.3641, fval 0.0200, Td = 13
% Kp = 4.39, Ki = 0.0713, Kd = 14.4
% Ti = 61.5708, Td = 3.2802

%step 30: param = 1.0468   10.7181   68.9720, fval 0.0142, Td = 9
% Kp = 1.82, Ki = 0.0313, Kd = 19.2
% Ti = 58.1470, Td = 10.5495

% mistake; Kp = 5.47; Ti = 54.7; Kd = 7.6965, Td = 9

%step 20 from 50: param = 0.2241   12.9128   69.7369, fval 0.0049,s Td = 8
% Kp = 9.37, Ki = 0.163, Kd = 116
% Ti = 57.4847, Td = 12.3799

%parametry od daniela 5 75 1.25

for delay = 8:8

        [param, fval(delay), flag] = fmincon(@approx_err,[0.5 20 25])

    data(1:350) = 0;
    data(delay+3:350) = 1; 
    Y(1:350) = s(50-delay-2:400-delay-3);

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
    decimal_comma(gca, 'XY');
    hold on;
    plot(Y);
    decimal_comma(gca, 'XY');

    % figure('Position',  [403 246 660 420]);
    figure;
    %title('PID z parametrami eksperymentalnymi, err=19.68');
    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(data);
    ylabel('$u$'); 
    xlabel('$k$');
     decimal_comma(gca, 'XY');
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Ymod);
    ylabel('$y$'); 
    hold on; 
    plot(Y);
     decimal_comma(gca, 'XY');

end