clear all;

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM4 % initialise com port

n = 1000;
Ypp = 32.31;
Upp = 30;
Yzad(1:n) = Ypp + 0;
Yzad(21:n) = Ypp + 7;
Yzad(201:n) = Ypp - 0.2;
Yzad(401:n) = Ypp + 2;
Yzad(601:n) = Ypp + 4.2;
Yzad(801:n) = Ypp + 0.5;
U(1:n) = Upp;
Y(1:n) = Ypp;
u = U - Upp;
err = 0;

%get step response from file
s = fscanf(fopen('step_response.txt', 'r'),'%f', [1 Inf]);
fclose('all');


D=300;
%optimal params
N=300; Nu=300; lambda=1; %err=15.6111

%init dUp
for i=1:D-1
    dup(i)=0;
end

%matrix gen

M=zeros(N,Nu);
for i=1:N
    for j=1:Nu
        if (i>=j)
            M(i,j)=s(i-j+1);
      end;
  end;
end;

Mp=zeros(N,D-1);
for i=1:N
    for j=1:D-1
        if i+j<=D
            Mp(i,j)=s(i+j)-s(j);
        else
            Mp(i,j)=s(D)-s(j);
        end;
    end;
end;

K=((M'*M+lambda*eye(Nu))^-1)*M';
Ku=K(1,:)*Mp;
Ke=sum(K(1,:));

%main loop

figure('Position',  [403 246 820 420]);
for i=3:n
    %% obtaining measurements
    measurements = readMeasurements(1:7); % read measurements from 1 to 7
    Y(i)=measurements(1);

    e=Yzad(i)-Y(i); %error
    err = err + e^2;

    du=Ke*e-Ku*dup'; %reg

    for n=D-1:-1:2
        dup(n)=dup(n-1);
    end
    dup(1)=du;
    u(i)=u(i-1)+dup(1);

    U(i)=u(i)+Upp;

    if U(i)>100
        U(i) = 100;
    end
    if U(i)<0
        U(i) = 0;
    end

    %% processing of the measurements and new control values calculation
    disp([i, U(i), Y(i), Yzad(i), err]); % process measurements

    %% sending new values of control signals
    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
    [50, 0, 0, 0, U(i), 0]);  % new corresponding control values

    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(U);
    ylabel('u');
    xlabel('k');
    decimal_comma(gca, 'XY');
    subplot('Position', [0.1 0.37 0.8 0.6]);
    plot(Y);
    ylabel('y');
    decimal_comma(gca, 'XY');
    hold on;
    stairs(Yzad,':');
    pause(0.01);
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready

end

err



