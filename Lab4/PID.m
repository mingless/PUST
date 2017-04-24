clear all
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
err = 0;

%values from optimization
K=7.19; Ti=102.8612; Td=0; Ts=1;%

r2 = K*Td/Ts;
r1 = K*(Ts/(2*Ti)-2*Td/Ts - 1);
r0 = K*(1+Ts/(2*Ti) + Td/Ts);

for k=21:n
    measurements = readMeasurements(1:7);
    Y(k)=measurements(1);

    e(k)=Yzad(k)-Y(k);
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
    disp([measurements(1), Upp, u(k), measurements(5), k, U(k), Y(k)]); % process measurements

    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
    [50, 0, 0, 0, U(k), 0]);  % new corresponding control values

    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready

end;

err = sum(e.^2)

figure('Position',  [403 246 820 420]);
subplot('Position', [0.1 0.12 0.8 0.15]);
stairs(U);
ylabel('u');
xlabel('k');
subplot('Position', [0.1 0.37 0.8 0.6]);

stairs(Y);
ylabel('y');
hold on;
stairs(Yzad,':');
