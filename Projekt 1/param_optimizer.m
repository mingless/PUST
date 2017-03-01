clear all;

%remove/lower the parameters in optimoptions to shorten optimization time


%DMC

%lb = [1,1,0.01];
%ub = [180,180,Inf];
%opts = optimoptions('ga', 'MaxStallGenerations', 100, 'PopulationSize',300);  %takes a few minutes
%[param,fval,exitflag] = ga(@DMC_err,3,[],[],[],[],lb,ub,[],[1 2],opts);
%fprintf('DMC: \nN=%f; Nu=%f; lambda=%f;\n', param)

%PID

lb = [0.01,1,0.01];
ub = [Inf,Inf,Inf];
opts = optimoptions('ga', 'MaxStallGenerations', 100, 'PopulationSize', 300);
[param,fval,exitflag] = ga(@PID_err,3,[],[],[],[],lb,ub,[],[],opts);
fprintf('PID: \nK=%f; Ti=%f; Td=%f; Ts=0.5;\n', param)