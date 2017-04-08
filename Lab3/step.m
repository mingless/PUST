clear all;
close all;

addpath('F:\SerialCommunication');  % add a path to the functions
initSerialControl COM4              % initialise com port

% określenie temperatur w punkcie pracy
% sterowanie:
%   G1 = 25 + 5 = 30
%   G2 = 30 + 5 = 35
%   W1 = W2 = 50

U1pp = 30;
U2pp = 35;
Y1pp = 35.31;
Y2pp = 35.87;

n = 400;            % długość symulacji
U1(1:n) = U1pp;     % zaczynamy z U1 punktu pracy
U2(1:n) = U2pp;     % zaczynamy z U2 punktu pracy
Y1(1:n) = Y1pp;     % Y1 punktu pracy
Y2(1:n) = Y2pp;     % Y2 punktu pracy

% skok G1 pomiar T3
U1(50:n) = U1pp; % 10 20 30

%% sending new values of control signals
%            [W1,W2,W3,W4,G1,G2]
sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
             [50,50, 0, 0,U1pp,U2pp]);  % new corresponding control values

figure('Position',  [403 0 620 725]);
i=1;
while(i<=n)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        Y1(i)=measurements(1);
        Y2(i)=measurements(3);
        %% processing of the measurements and new control values calculation
        disp([measurements(1:3), i]); % process measurements

        %% sending new values of control signals
        %            [W1,W2,W3,W4,G1,G2]
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50,50, 0, 0,U1(i),U2(i)]);  % new corresponding control values

        subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
        stairs(U2);
        xlabel('k');
        ylabel('u_2');
        subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
        stairs(U1);
        ylabel('u_1');
        subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
        plot(Y2);
        ylabel('y_2');
        subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
        plot(Y1);
        ylabel('y_1');
        pause(0.01);

        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
        i=i+1;
end

% dlmwrite('T1pp.txt', Y1, ' ');
% dlmwrite('T3pp.txt', Y2, ' ');
% dlmwrite('G1_step_10_T1.txt', Y1, ' ');
% dlmwrite('G1_step_10_T3.txt', Y2, ' ');

% dlmwrite('G1_step_20_T1.txt', Y1, ' ');
% dlmwrite('G1_step_20_T3.txt', Y2, ' ');

% dlmwrite('G1_step_30_T1.txt', Y1, ' ');
% dlmwrite('G1_step_30_T3.txt', Y2, ' ');

%dlmwrite('G2_step_30_T3.txt', Y2, ' ');
%dlmwrite('G2_step_30_T1.txt', Y1, ' ');


% S=zeros(2,2,n-50);
% S(1,1,:)=Y1(51:n);
% S(2,1,:)=Y2(51:n);

% odpowiedź skokowa z zad 2 do zad 3

%figure('Position',  [403 0 620 620]);
%subplot(2,2,1);
%stairs(squeeze(S(1,1,:))); %squeeze func removes singleton dimensions
%ylabel('s^{11}');
%ylim([0 2.5]);
%decimal_comma(gca,'XY');
%subplot(2,2,2);
%stairs(squeeze(S(1,2,:)));
%ylabel('s^{12}');
%ylim([0 2.5]);
%decimal_comma(gca,'XY');
%subplot(2,2,3);
%stairs(squeeze(S(2,1,:)));
%ylabel('s^{21}');
%ylim([0 2.5]);
%xlabel('k');
%decimal_comma(gca,'XY');
%subplot(2,2,4);
%stairs(squeeze(S(2,2,:)));
%ylabel('s^{22}');
%ylim([0 2.5]);
%xlabel('k');
%decimal_comma(gca,'XY');

% charakterystyka statyczna do zad 2
%U1s(1:41) = 0;
%U2s(1:41) = 0;
%Y1s(1:41,1:41) = 0;
%Y2s(1:41,1:41) = 0;
%for i = 1:41
    %U1s(i) = 0 - 0.5 + (i-1)*(1/40);
    %for j = 1:41
        %U2s(j) = 0 - 0.5 + (j-1)*(1/40);
        %U1(1:10) = 0;
        %U1(10:n) = U1s(i);
        %U2(1:10) = 0;
        %U2(10:n) = U2s(j);
        %for k = 10:n
             %Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
             %Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
        %end
        %Y1s(i,j) = Y1(n);
        %Y2s(i,j) = Y2(n);
    %end
%end
%figure;
%surf(U1s, U2s, Y1s);
%decimal_comma(gca, 'XY');
%xlabel('U_{1s}');
%ylabel('U_{2s}');
%zlabel('Y_{1s}');

%figure;
%surf(U1s, U2s, Y2s);
%decimal_comma(gca, 'XY');
%xlabel('U_{1s}');
%ylabel('U_{2s}');
%zlabel('Y_{2s}');


%close all;
