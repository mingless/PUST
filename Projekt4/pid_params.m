function [K, Ti, Td] = pid_params(ustart,ymin, ymax)
    
optfun = @(param) PID_err(param(1),param(2),param(3),ustart,ymin,ymax);

[x, fval, flag] = fmincon(optfun,[1, 2, 2],[],[],[],[],[0 0 0],[]);
K = x(1); Ti = x(2); Td = x(3);

end

function err = PID_err( K,Ti,Td,ustart,ymin,ymax )

n = 2500;
Yzad(1:n) = ymin;  
Yzad(21:n) = ymax; 
Yzad(501:n)= ymin;  
Yzad(1001:n) = (ymax+ymin)/2;
U(1:n) = ustart; %inicjalizacja sterowania
Y(1:n) = ymin; %inicjalizacja wyjscia
err = 0;

Ts = 0.5;% K = param(1); Ti = param(2); Td = param(3);

r2 = K*Td/Ts; r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1); r0 = K*(1+Ts/(2*Ti) + Td/Ts);

%glowna petla PID
for k=21:n 
     Y(k)=symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2)); 
     e(k)=Yzad(k)-Y(k); %blad wyjscia
     
     du = r2*e(k-2)+r1*e(k-1)+r0*e(k);
     
     U(k)=du+U(k-1); 
%      if U(k)>1 %ograniczenia na min/max sygnalu sterowania
%          U(k) = 1; %uniemozliwiaja optymalizacje z losowymi param. pocz.
%      end
%      if U(k)<-1
%          U(k) = -1;
%      end
end; 

% err = sum(e.^2);
err = sum(abs(e)); %zastosowanie tej funkcji bledu skutkuje mniejszymi
                   %oscylacjami, ale wolniejszym zejsciem ze skoku


end

