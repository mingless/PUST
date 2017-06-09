close all;
clear all;

n = 600;




Yzad(1:3,1:n)=0;
Yzad(1,21:end)=1.4;
Yzad(1,151:end)=-1.8;
Yzad(1,301:end)=0.2;
Yzad(1,501:end)=-0.8;
Yzad(2,76:end)=-0.3;
Yzad(2,201:end)=0.9;
Yzad(2,401:end)=-0.7;
Yzad(3,101:end)=1.2;
Yzad(3,251:end)=-0.8;
Yzad(3,351:end)=1.6;
Yzad(3,451:end)=-1.3;

U(1:4,1:n)=0;
Y(1:3,1:n)=0;

err = 0;

%reg1 Kkryt = 12.66
%reg2 Kkryt = 10.01
%reg3 Kkryt = 3.5


%parametry dobrane z fmincon(@PID_err,[1.1 9 0.8 3.45 9 0.3 1 200 0.2],[],[],[],[],[0 0 0 0 0 0 0 0 0],[])
% K(1)=12.66/7; Ti(1)=0.7929; Td(1)=0.0000; Ts(1)=0.5;
% K(2)=10.01/7; Ti(2)=0.1055; Td(2)=1.0847; Ts(2)=0.5;
% K(3)=3.5/7; Ti(3)=0.3268; Td(3)=0.3698; Ts(3)=0.5;
K(1)=6.882182906513113; Ti(1)=1.010052168859802; Td(1)=6.953707331392322e-05; Ts(1)=0.5;
K(2)=5.749610700569483; Ti(2)=0.577649802082669; Td(2)=8.254360836520393e-05; Ts(2)=0.5;
K(3)=6.174822145907889; Ti(3)=16.425533517861780; Td(3)=0.025270149753524; Ts(3)=0.5;
% x = [6.882182906513113 1.010052168859802 6.953707331392322e-05 5.749610700569483 0.577649802082669 8.254360836520393e-05 6.174822145907889 16.425533517861780 0.025270149753524]
% K(1)=x(1); Ti(1)=x(2); Td(1)=x(3); Ts(1)=0.5;
% K(2)=x(4); Ti(2)=x(5); Td(2)=x(6); Ts(2)=0.5;
% K(3)=x(7); Ti(3)=x(8); Td(3)=x(9); Ts(3)=0.5;

e(1:3,1:n)=0;

K=K'; Ti=Ti'; Td=Td'; Ts=Ts';


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);


%glowna petla PID
for k=21:n 
     [Y(1,k),Y(2,k),Y(3,k)]=symulacja_obiektu4(U(1,k-1),U(1,k-2),U(1,k-3),U(1,k-4),...
                     U(2,k-1),U(2,k-2),U(2,k-3),U(2,k-4),...
                     U(3,k-1),U(3,k-2),U(3,k-3),U(3,k-4),...
                     U(4,k-1),U(4,k-2),U(4,k-3),U(4,k-4),...
                     Y(1,k-1),Y(1,k-2),Y(1,k-3),Y(1,k-4),...
                     Y(2,k-1),Y(2,k-2),Y(2,k-3),Y(2,k-4),...
                     Y(3,k-1),Y(3,k-2),Y(3,k-3),Y(3,k-4));

     
     e(:,k)=Yzad(:,k)-Y(:,k); %blad wyjscia
     
     du = r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k);
     
     
     U([1 2 4],k)=du(:)+U([1 2 4],k-1); 
end 

err = trace(e'*e) %blad funkcji

figure('Position',  [403 0 620 930]);
subplot('Position', [0.1 0.0538 0.8 0.0452]); %42 at 50
stairs(U(4,:));
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('$u_4$');
subplot('Position', [0.1 0.1452 0.8 0.0452]); %42 at 135
stairs(U(3,:));
decimal_comma(gca, 'XY');
ylabel('$u_3$');
subplot('Position', [0.1 0.2366 0.8 0.0452]); %42 at 220
stairs(U(2,:));
decimal_comma(gca, 'XY');
ylabel('$u_2$');
subplot('Position', [0.1 0.3280 0.8 0.0452]); %42 at 305
stairs(U(1,:));
decimal_comma(gca, 'XY');
ylabel('$u_1$');
subplot('Position', [0.1 0.4194 0.8 0.1505]); %140 at 390
plot(Y(3,:));
hold on
plot(Yzad(3,:),':');
decimal_comma(gca, 'XY');
ylabel('$y_3$');
subplot('Position', [0.1 0.6129 0.8 0.1505]); %140 at 570
plot(Y(2,:));
hold on
plot(Yzad(2,:),':');
decimal_comma(gca, 'XY');
ylabel('$y_2$');
subplot('Position', [0.1 0.8065 0.8 0.1505]); %140 at 750
plot(Y(1,:));
hold on
plot(Yzad(1,:),':');
decimal_comma(gca, 'XY');
ylabel('$y_1$');
