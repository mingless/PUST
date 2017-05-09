clear all
addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM3 % initialise com port

n = 1350;
Ypp = 32.9;
Upp = 30;
Yzad(1:n) = Ypp + 0;
Yzad(21:n) = Ypp - 1;
Yzad(151:n) = Ypp + 3;
Yzad(401:n) = Ypp + 9;
Yzad(701:n) = Ypp + 7;
Yzad(901:n) = Ypp + 11;
Yzad(1151:n) = Ypp + 9.5;
U(1:n) = Upp;
Y(1:n) = Ypp;
u = U - Upp;
err = 0;

%values from optimization
K=5.47; Ti=54.7; Td=7.69; Ts=1;%

r2 = K*Td/Ts;
r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1);
r0 = K*(1+Ts/(2*Ti) + Td/Ts);

sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
             [50, 0, 0, 0, 0, 0]);  % new corresponding control values

sendNonlinearControls(U(1));
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

    %% sending new values of control signals
    sendNonlinearControls(U(k));

    subplot('Position', [0.1 0.12 0.8 0.15]);
    stairs(U);
    ylabel('u');
    xlabel('k');
    subplot('Position', [0.1 0.37 0.8 0.6]);

    stairs(Y);
    ylabel('y');
    hold on;
    stairs(Yzad,':');
    hold off;
    pause(0.01);

    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready

end;

err = sum(e.^2)

