clear all
addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM17 % initialise com port

n = 1200;
Ypp = 32.9;
Upp = 30;
Yzad(1:n) = Ypp + 0;
Yzad(21:n) = Ypp + 7;
Yzad(201:n) = Ypp + 12;
Yzad(401:n) = Ypp + 19;
Yzad(601:n) = Ypp + 5;
Yzad(801:n) = Ypp + 1;
Yzad(1001:n) = Ypp + 9;
U(1:n) = Upp;
Y(1:n) = Ypp;
err = 0;

%values from optimization
K=1.8; Ti=56.4263; Td=10.3333; Ts=1;%

r2 = K*Td/Ts;
r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1);
r0 = K*(1+Ts/(2*Ti) + Td/Ts);

figure('Position',  [403 246 820 420]);
for k=3:n
    measurements = readMeasurements(1:7);
    Y(k)=measurements(1);

    e(k)=Yzad(k)-Y(k);
    err = err + e(k)^2;
    %% processing of the measurements and new control values calculation

    du = r2*e(k-2)+r1*e(k-1)+r0*e(k);

    u(k)=du+u(k-1);

    U(k)= u(k) + Upp;

    if U(k)>100
        U(k) = 100;
    end

    if U(k)<0
        U(k) = 0;
    end

    %% sending new values of control signals
    disp([k, U(k), Y(k), Yzad(k), err]); % process measurements

    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
    [50, 0, 0, 0, U(k), 0]);  % new corresponding control values

    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(U);
    ylabel('u');
    xlabel('k');
    subplot('Position', [0.1 0.37 0.8 0.6]);

    stairs(Y);
    ylabel('y');
    hold on;
    stairs(Yzad,':');
    pause(0.01);

    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready

end;

err = sum(e.^2)

