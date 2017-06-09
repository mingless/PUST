clear all;
close all;

n = 200; 
U = cell(1,4);
Y = cell(1,3);
U(1:4) = mat2cell(zeros(1,n),1,n); 
Y(1:3) = mat2cell(zeros(1,n),1,n);  
Y1(1:n) = 0;
Y2(1:n) = 0;
U1(1:n) = 0;
U2(1:n) = 0;
% sprawdzenie odpowiedzi w punkcie pracy
for k = 12:n
    Y1(k) = symulacja_obiektu4y1(U1(k-6), U1(k-7), U2(k-2), U2(k-3), Y1(k-1), Y1(k-2));
    Y2(k) = symulacja_obiektu4y2(U1(k-2), U1(k-3), U2(k-3), U2(k-4), Y2(k-1), Y2(k-2));
    [Y{1}(k),Y{2}(k),Y{3}(k)]=symulacja_obiektu4(U{1}(k-1),U{1}(k-2),U{1}(k-3),U{1}(k-4),...
                     U{2}(k-1),U{2}(k-2),U{2}(k-3),U{2}(k-4),...
                     U{3}(k-1),U{3}(k-2),U{3}(k-3),U{3}(k-4),...
                     U{4}(k-1),U{4}(k-2),U{4}(k-3),U{4}(k-4),...
                     Y{1}(k-1),Y{1}(k-2),Y{1}(k-3),Y{1}(k-4),...
                     Y{2}(k-1),Y{2}(k-2),Y{2}(k-3),Y{2}(k-4),...
                     Y{3}(k-1),Y{3}(k-2),Y{3}(k-3),Y{3}(k-4));
end

figure('Position',  [403 0 620 930]);
subplot('Position', [0.1 0.0538 0.8 0.0452]); %42 at 50
stairs(U{4});
decimal_comma(gca, 'XY');
xlabel('k');
ylabel('$u_4$');
subplot('Position', [0.1 0.1452 0.8 0.0452]); %42 at 135
stairs(U{3});
decimal_comma(gca, 'XY');
ylabel('$u_3$');
subplot('Position', [0.1 0.2366 0.8 0.0452]); %42 at 220
stairs(U{2});
decimal_comma(gca, 'XY');
ylabel('$u_2$');
subplot('Position', [0.1 0.3280 0.8 0.0452]); %42 at 305
stairs(U{1});
decimal_comma(gca, 'XY');
ylabel('$u_1$');
subplot('Position', [0.1 0.4194 0.8 0.1505]); %140 at 390
plot(Y{3});
decimal_comma(gca, 'XY');
ylabel('$y_3$');
subplot('Position', [0.1 0.6129 0.8 0.1505]); %140 at 570
plot(Y{2});
decimal_comma(gca, 'XY');
ylabel('$y_2$');
subplot('Position', [0.1 0.8065 0.8 0.1505]); %140 at 750
plot(Y{1});
decimal_comma(gca, 'XY');
ylabel('$y_1$');

n=200;
S=zeros(3,4,n-20);
% skok jednostkowy u1 w chwili k=20
U(1:4) = mat2cell(zeros(1,n),1,n); 
Y(1:3) = mat2cell(zeros(1,n),1,n); 
U{1}(20:n) = 1;



U1(20:n) = 1;
for k = 21:n
    [Y{1}(k),Y{2}(k),Y{3}(k)]=symulacja_obiektu4(U{1}(k-1),U{1}(k-2),U{1}(k-3),U{1}(k-4),...
                     U{2}(k-1),U{2}(k-2),U{2}(k-3),U{2}(k-4),...
                     U{3}(k-1),U{3}(k-2),U{3}(k-3),U{3}(k-4),...
                     U{4}(k-1),U{4}(k-2),U{4}(k-3),U{4}(k-4),...
                     Y{1}(k-1),Y{1}(k-2),Y{1}(k-3),Y{1}(k-4),...
                     Y{2}(k-1),Y{2}(k-2),Y{2}(k-3),Y{2}(k-4),...
                     Y{3}(k-1),Y{3}(k-2),Y{3}(k-3),Y{3}(k-4));
end

S(1,1,:)=Y{1}(21:n);
S(2,1,:)=Y{2}(21:n);
S(3,1,:)=Y{3}(21:n);

U{1}(20:n) = 0;
U{2}(20:n) = 1;
for k = 21:n
    [Y{1}(k),Y{2}(k),Y{3}(k)]=symulacja_obiektu4(U{1}(k-1),U{1}(k-2),U{1}(k-3),U{1}(k-4),...
                     U{2}(k-1),U{2}(k-2),U{2}(k-3),U{2}(k-4),...
                     U{3}(k-1),U{3}(k-2),U{3}(k-3),U{3}(k-4),...
                     U{4}(k-1),U{4}(k-2),U{4}(k-3),U{4}(k-4),...
                     Y{1}(k-1),Y{1}(k-2),Y{1}(k-3),Y{1}(k-4),...
                     Y{2}(k-1),Y{2}(k-2),Y{2}(k-3),Y{2}(k-4),...
                     Y{3}(k-1),Y{3}(k-2),Y{3}(k-3),Y{3}(k-4));
end

S(1,2,:)=Y{1}(21:n);
S(2,2,:)=Y{2}(21:n);
S(3,2,:)=Y{3}(21:n);

U{2}(20:n) = 0;
U{3}(20:n) = 1;
for k = 21:n
    [Y{1}(k),Y{2}(k),Y{3}(k)]=symulacja_obiektu4(U{1}(k-1),U{1}(k-2),U{1}(k-3),U{1}(k-4),...
                     U{2}(k-1),U{2}(k-2),U{2}(k-3),U{2}(k-4),...
                     U{3}(k-1),U{3}(k-2),U{3}(k-3),U{3}(k-4),...
                     U{4}(k-1),U{4}(k-2),U{4}(k-3),U{4}(k-4),...
                     Y{1}(k-1),Y{1}(k-2),Y{1}(k-3),Y{1}(k-4),...
                     Y{2}(k-1),Y{2}(k-2),Y{2}(k-3),Y{2}(k-4),...
                     Y{3}(k-1),Y{3}(k-2),Y{3}(k-3),Y{3}(k-4));
end

S(1,3,:)=Y{1}(21:n);
S(2,3,:)=Y{2}(21:n);
S(3,3,:)=Y{3}(21:n);

U{3}(20:n) = 0;
U{4}(20:n) = 1;
for k = 21:n
    [Y{1}(k),Y{2}(k),Y{3}(k)]=symulacja_obiektu4(U{1}(k-1),U{1}(k-2),U{1}(k-3),U{1}(k-4),...
                     U{2}(k-1),U{2}(k-2),U{2}(k-3),U{2}(k-4),...
                     U{3}(k-1),U{3}(k-2),U{3}(k-3),U{3}(k-4),...
                     U{4}(k-1),U{4}(k-2),U{4}(k-3),U{4}(k-4),...
                     Y{1}(k-1),Y{1}(k-2),Y{1}(k-3),Y{1}(k-4),...
                     Y{2}(k-1),Y{2}(k-2),Y{2}(k-3),Y{2}(k-4),...
                     Y{3}(k-1),Y{3}(k-2),Y{3}(k-3),Y{3}(k-4));
end

S(1,4,:)=Y{1}(21:n);
S(2,4,:)=Y{2}(21:n);
S(3,4,:)=Y{3}(21:n);


%first batch (u12)
figure('Position',  [403 0 620 620]);
subplot(3,2,1);
stairs(squeeze(S(1,1,:))); %squeeze func removes singleton dimensions
ylabel('$s^{11}$');
ylim([0 2]);
decimal_comma(gca,'XY');
subplot(3,2,2);
stairs(squeeze(S(1,2,:)));
ylabel('$s^{12}$');
ylim([0 2]);
decimal_comma(gca,'XY');
subplot(3,2,3);
stairs(squeeze(S(2,1,:)));
ylabel('$s^{21}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,4);
stairs(squeeze(S(2,2,:)));
ylabel('$s^{22}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,5);
stairs(squeeze(S(3,1,:)));
ylabel('$s^{31}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,6);
stairs(squeeze(S(3,2,:)));
ylabel('$s^{32}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');


%second batch (u34)
figure('Position',  [403 0 620 620]);
subplot(3,2,1);
stairs(squeeze(S(1,3,:))); %squeeze func removes singleton dimensions
ylabel('$s^{13}$');
ylim([0 2]);
decimal_comma(gca,'XY');
subplot(3,2,2);
stairs(squeeze(S(1,4,:)));
ylabel('$s^{14}$');
ylim([0 2]);
decimal_comma(gca,'XY');
subplot(3,2,3);
stairs(squeeze(S(2,3,:)));
ylabel('$s^{23}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,4);
stairs(squeeze(S(2,4,:)));
ylabel('$s^{24}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,5);
stairs(squeeze(S(3,3,:)));
ylabel('$s^{33}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');
subplot(3,2,6);
stairs(squeeze(S(3,4,:)));
ylabel('$s^{34}$');
ylim([0 2]);
xlabel('k');
decimal_comma(gca,'XY');

%K = squeeze(S(:,:,end))' %macierz wzmocnien
%cond(K([2 3 4],:))
%cond(K([1 3 4],:))
%cond(K([1 2 4],:)) % <- min, ignorujemy trzecie wejscie w PID
%cond(K([1 2 3],:))
%(K([1 2 4],:).*(K([1 2 4],:)^-1))'
%result: u1>y1,u2>y2,u3>y3



    

%close all;