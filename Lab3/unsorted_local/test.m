s11(1:50)=0;
s11(51:400) = fscanf(fopen('s11.txt','r'),'%f');
s21(1:50)=0;
s21(51:400) = fscanf(fopen('s21.txt','r'),'%f');

u1(1:50) = 0;
u1(51:400)=1;
u2(1:400)=0;

data = iddata([s11' s21'],[u1' u2'],1);

plot(data);

s12(1:50)=0;
s12(51:400) = fscanf(fopen('s12.txt','r'),'%f');
s22(1:50)=0;
s22(51:400) = fscanf(fopen('s22.txt','r'),'%f');

u2(1:50) = 0;
u2(51:400)=1;
u1(1:400)=0;

data2 = iddata([s12' s22'],[u1' u2'],1);

plot(data2);

