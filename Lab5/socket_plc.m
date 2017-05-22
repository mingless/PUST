%%Socket Communication demo script

%t = tcpip('192.168.127.250',4000, 'NetworkRole', 'client');

delete(instrfindall)

pause(2);

%%fclose(t);
%%delete(t);
%%clear t;

close all;
clear all;
 
 
%%t = tcpip('192.168.0.150',4000);
 
t = tcpip('192.168.127.250',4000, 'NetworkRole', 'client');

t.OutputBufferSize = 3000;
t.InputBufferSize = 3000;
 
fopen(t);
fprintf('Fopen zadzialal');
iterator = 1;
data = zeros(4,2);
figure(1);

y1 = [];
y2 = [];
u1 = [];
u2 = [];
yzad1 = [];
yzad2 = [];

while(1)   
    if (t.BytesAvailable ~= 0)
        temp = fscanf(t);
        temp
        eval(temp);
        y1 = [y1 Y1];
        y2 = [y2 Y2];
        u1 = [u1 U1];
        u2 = [u2 U2];
        yzad1 = [yzad1 Yzad1];
        yzad2 = [yzad2 Yzad2];
       
%         fprintf('Fscanf zadzialal');
%         iterator=iterator + 1;
%         subplot(2,2,1);
%         plot(1:length(data(2,:)), data(2,:));
%         subplot(2,2,2);
%         plot(1:length(data(1,:)), data(1,:));
%         subplot(2,2,3);
%         plot(1:length(data(4,:)), data(4,:));
%         subplot(2,2,4);
%         plot(1:length(data(3,:)), data(3,:));
        subplot(2,2,1);
        plot(1:length(y1), y1);
        hold on
        plot(1:length(yzad1),yzad1,':');
        hold off
        subplot(2,2,2);
        plot(1:length(u1), u1);
        subplot(2,2,3);
        plot(1:length(y2), y2);
        hold on
        plot(1:length(yzad2),yzad2,':');
        hold off
        subplot(2,2,4);
        plot(1:length(u2), u2);
    end
    pause(0.05);
end

fclose(t);
delete(t);
clear t;


%fprintf(t,'Init comm');
 
 
%fclose(t);



%fopen(t); 

iter = 1;
%data = fread(t,2);
read_done = 0;
while(read_done == 0)
    pause(1);
    fprintf(t,'Waiting for response from server %d\n',iter);
    iter = iter + 1;
%     if (t.BytesAvailable ~= 0)
%         data = fread(t,t.BytesAvailable);
%         read_done = 1;
%     end
    temp = fscanf(t);
    temp

end
data

temp = fscanf(t);

temp

fclose(t);
delete(t);
clear t;