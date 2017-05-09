
function err = approx_err(param)
global delay
% data(1:300) = 0;
% data(50:300) = 1;
% Y(1:300) = 0;
% Y(50:300) = 0.5;
% Y(100:300) = 1;
s = fscanf(fopen('G1_step_50_20.txt', 'r'), '%f', [1 inf]);
s = (s-41.56)/20;
fclose('all');
% delay = 3;
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

err = sum((Ymod - Y').^2);

end