function err = PID_err(param)

n = 1200;
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


K(1)=param(1); Ti(1)=param(2); Td(1)=param(3); Ts(1)=0.5; 
% K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
K(2)=param(4); Ti(2)=param(5); Td(2)=param(6); Ts(2)=0.5;
% K(2)=0; Ti(2)=inf; Td(2)=0; Ts(2)=0.5; 
% K(1)=0; Ti(1)=inf; Td(1)=0; Ts(1)=0.5;
% K(2)=4.45; Ti(2)=6; Td(2)=0.1; Ts(2)=0.5;
% K(1)=0.3; Ti(1)=1; Td(1)=0.5; Ts(1)=0.5;
e(1:2,1:n)=0;

K=K'; Ti=Ti'; Td=Td'; Ts=Ts';


r2 = K.*Td./Ts; r1 = K.*(Ts./(2.*Ti)-2.*Td./Ts - 1); r0 = K.*(1+Ts./(2.*Ti) + Td./Ts);


%glowna petla PID
for k=21:n 
     Y(1,k) = symulacja_obiektu4y1(U(1,k-6), U(1,k-7), U(2,k-2), U(2,k-3), Y(1,k-1), Y(1,k-2));
     Y(2,k) = symulacja_obiektu4y2(U(1,k-2), U(1,k-3), U(2,k-3), U(2,k-4), Y(2,k-1), Y(2,k-2));
    
     e(:,k)=Yzad(:,k)-Y(:,k); %blad wyjscia
     
     du = r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k);
     
     U(:,k)=du(:)+U(:,k-1); 
end; 

err = trace(e'*e) %blad funkcji

end