
function err = approx_err(param)
global delay
% data(1:300) = 0;
% data(50:300) = 1;
% Y(1:300) = 0;
% Y(50:300) = 0.5;
% Y(100:300) = 1;
s = fscanf(fopen('step1.txt', 'r'), '%f', [1 inf]);
s = (s-32.31)/10;
fclose('all');
% delay = 3;
data(1:400) = 0;
data(delay+3:400) = 1;
Y(1:400) = s(350-delay-2:750-delay-3);

K = param(1); T1 = param(2); T2 = param(3);
alp1 = exp(-1/T1);
alp2 = exp(-1/T2);
a1 = -alp1 - alp2;
a2 = alp1*alp2;
b1 = K/(T1-T2) * (T1 * (1 - alp1) - T2 * (1 -alp2));
b2 = K/(T1-T2) * (alp1 * T2 * (1 - alp2) - alp2 * T1 * (1 - alp1));
b = [b1 b2 -a1 -a2]';

Ymod = modelout(data,b,delay);

err = sum((Ymod - Y').^2);

end