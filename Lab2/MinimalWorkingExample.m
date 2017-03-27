%function [Y]= MinimalWorkingExample()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM4 % initialise com port
    n=350;
    Y=zeros(n,1);
    i = 1;
    k = 50;
    z(1:k) = 0;
    z(k+1:n) = 0; % 10 20 30
    u(1:k) = 30;
    u(k+1:n) = 30;
    
     %% sending new values of control signals
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50, 0, 0, 0, 0, 0]);  % new corresponding control values
    
    while(i<=n)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        Y(i)=measurements(1);
        %% processing of the measurements and new control values calculation
        disp([measurements(1), i]); % process measurements
        
        sendControlsToG1AndDisturbance(u(i), z(i));
        
        stairs(Y);
        pause(0.01);
        
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
        i=i+1;
        
    end
    
    dlmwrite('skoku10_2.txt', Y, ' ');
%end