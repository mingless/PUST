close all;
clear all;

n = 1200;

szum = 0; snr = 20;
zakl = 1;

Z(1:2,1:n) = 0.0;
Z(1,301:end)=-0.1;
Z(2,701:end)=-0.1;


Ypom(1:2,1:n)=0;
Yzad(1:2,1:n)=0;
Yzad(1,21:end)=1.4;
Yzad(1,601:end)=0.2;
Yzad(1,1001:end)=-0.8;
Yzad(2,151:end)=-0.3;
Yzad(2,401:end)=0.9;
Yzad(2,801:end)=-0.7;

U(1:2,1:n)=0;
Y(1:2,1:n)=0;

err = 0;

%przy reg1: oscylacje krytyczne przy K1=2.2, Tk1=20;
%przy reg2: oscylacje krytyczne przy K2=6.9, Tk2=10;
%po zamianie we/wy
%przy reg1: oscylacje krytyczne przy K1=4.6, Tk1=5;
%przy reg2: oscylacje krytyczne przy K2=11.9, Tk2=5;
%Z-N nie dzialal (?)

%Eksperymentalnie


% K(1)=1.1; Ti(1)=9; Td(1)=0.8; Ts(1)=0.5; 
% % K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
% K(2)=3.45; Ti(2)=9; Td(2)=0.3; Ts(2)=0.5;
% K(2)=0; Ti(2)=inf; Td(2)=0; Ts(2)=0.5; 
% K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
% K(2)=4.45; Ti(2)=6; Td(2)=0.1; Ts(2)=0.5;
% K(1)=0.3; Ti(1)=1; Td(1)=0.5; Ts(1)=0.5;

%parametry dobrane z fmincon(@PID_err,[1.1 9 0.8 3.45 9 0.3],[],[],[],[],[0 0 0 0 0 0],[])
K(1)=1.1576; Ti(1)=12.5191; Td(1)=1.4089; Ts(1)=0.5;
K(2)=0.8789; Ti(2)=7.9788; Td(2)=0.5366; Ts(2)=0.5;
e(1:2,1:n)=0;

K=K'; Ti=Ti'; Td=Td'; Ts=Ts';


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);


%glowna petla PID
for k=21:n 
     Y(1,k) = symulacja_obiektu4y1(U(1,k-6), U(1,k-7), U(2,k-2), U(2,k-3), Y(1,k-1), Y(1,k-2));
     Y(2,k) = symulacja_obiektu4y2(U(1,k-2), U(1,k-3), U(2,k-3), U(2,k-4), Y(2,k-1), Y(2,k-2));
     
     if zakl
         Y(1,k) = Y(1,k) + Z(1,k);
         Y(2,k) = Y(2,k) + Z(2,k);
     end
     
     if szum %dodanie szumu
         Ypom(:,k) = awgn(Y(:,k),snr);
     else
         Ypom(:,k) = Y(:,k);
     end
     
     e(:,k)=Yzad(:,k)-Ypom(:,k); %blad wyjscia
     
     du = r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k);
     
     U(:,k)=du(:)+U(:,k-1); 
end; 

err = trace(e'*e) %blad funkcji

if ~zakl %plot tylko z U(1,2) i Y(1,2)
    figure('Position',  [403 0 620 725]);
    subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
    stairs(U(2,:));
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
    stairs(U(1,:));
    % ylim([-5 5]);
    decimal_comma(gca, 'XY');
    ylabel('u_1');
    subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
    ff = plot(Y(2,:));
    hold on;
    plot(Yzad(2,:));
    if szum
        plot(Ypom(2,:));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_2');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    ff = plot(Y(1,:));
    hold on;
    plot(Yzad(1,:));
    if szum
        plot(Ypom(1,:));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_1');
else %splotuj tez Z(1,2)
    h = figure('Position',  [403 0 620 935]); 
    subplot('Position', [0.1 0.0535 0.8 0.0663]); %62 at 50
    stairs(U(2,:));
    decimal_comma(gca, 'XY');
    xlabel('k');
    ylabel('u_2');
    subplot('Position', [0.1 0.1658 0.8 0.0663]); %62 at 155
    stairs(U(1,:));
    % ylim([-5 5]);
    decimal_comma(gca, 'XY');
    ylabel('u_1');
    subplot('Position', [0.1 0.2781 0.8 0.0663]); %62 at 260
    stairs(Z(2,:));
    decimal_comma(gca, 'XY');
    ylabel('z_2');
    subplot('Position', [0.1 0.3904 0.8 0.0663]); %62 at 365
    stairs(Z(1,:));
    % ylim([-5 5]);
    decimal_comma(gca, 'XY');
    ylabel('z_1');
    subplot('Position', [0.1 0.5027 0.8 0.2139]); %200 at 470
    ff = plot(Y(2,:));
    hold on;
    plot(Yzad(2,:));
    if szum
        plot(Ypom(2,:));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_2');
    subplot('Position', [0.1 0.7594 0.8 0.2139]); %200 at 710
    ff = plot(Y(1,:));
    hold on;
    plot(Yzad(1,:));
    if szum
        plot(Ypom(1,:));
        uistack(ff,'top');
    end
    decimal_comma(gca, 'XY');
    ylabel('y_1');
end
    