function err = test(lam)
    reg = 6;

    %uznajemy ze D = N = Nu dla uproszczenia. mozna dodac recznie inne wartosci
    if reg == 1
        trapu = [-1 -0.9 0.9 1];
        D = {50};
        lambda = {lam(1)};
    elseif reg == 2
        trapu = [-1 -0.9 0.2 0.3;...
                0.2 0.3 0.9 1];
        D = {30, 50};
        lambda = {lam(1), lam(2)};
    elseif reg == 3
        trapu = [-1 -0.9 0.1 0.2;...
                0.1 0.2 0.5 0.6;...
                0.5 0.6 0.9 1];
        D = {30, 40, 50};
        lambda = {lam(1), lam(2), lam(3)};
    elseif reg == 4
        trapu = [-1 -0.9 0 0.1;...
                0 0.1 0.2 0.3;...
                0.2 0.3 0.5 0.6;...
                0.5 0.6 0.9 1];
        D = {30, 30, 40, 50};
        lambda = {lam(1), lam(2), lam(3), lam(4)};
    elseif reg == 5
        trapu = [-1 -0.9 0 0.1;...
                0 0.1 0.15 0.25;...
                0.15 0.25 0.35 0.45;...
                0.35 0.45 0.5 0.6;...
                0.5 0.6 0.9 1];
        D = {30, 30, 40, 40, 50};
        lambda = {lam(1), lam(2), lam(3), lam(4), lam(5)};
    elseif reg == 6
        trapu = [-1 -0.9 0 0.05;...
                0 0.05 0.10 0.15;...
                0.10 0.15 0.20 0.25;...
                0.20 0.25 0.35 0.45;...
                0.35 0.45 0.5 0.6;...
                0.5 0.6 0.9 1];
        D = {30, 30, 30, 40, 40, 50};
        lambda = {lam(1), lam(2), lam(3), lam(4), lam(5), lam(6)};
    end

    N = D;
    Nu = D;

    trapy = arrayfun(@stat_val,trapu); %przypisanie konkretnych granic Y
    trapy(1,1:2)=-inf; %rozszerzenie granic koncowych do nieskonczonosci
    trapy(end,3:4)=inf;

    s = cell(1, reg);

    for i = 1:reg
        s{i} = get_step_resp(trapu(i,2),trapu(i,3));
    end



    n = 1000;
    Yzad(1:n) = 0;  
    Yzad(21:n) = 7;
    Yzad(201:n)= -0.2;  
    Yzad(401:n)= 2; 
    Yzad(601:n)=4.2; 
    Yzad(801:n)=0.5;
    U(1:n) = 0; 
    Y(1:n) = 0;
    err = 0;


    % D=120; 
    % %parametry regulatora dobrane eksperymentalnie
    % N=120; Nu=120; lambda=2111; %err=15.6111



    dup = cell(1,reg);
    M = cell(1,reg);
    Mp = cell(1,reg);
    K = cell(1,reg);
    Ku = cell(1,reg);
    Ke = cell(1,reg);

    for k = 1:reg
        dup{k}(1:D{k}-1) = 0;

        M{k}=zeros(N{k},Nu{k});
        for i=1:N{k}
           for j=1:Nu{k}
              if (i>=j)
                 M{k}(i,j)=s{k}(i-j+1);
              end;
           end;
        end;

        Mp{k}=zeros(N{k},D{k}-1);
        for i=1:N{k}
           for j=1:D{k}-1
              if i+j<=D{k}
                 Mp{k}(i,j)=s{k}(i+j)-s{k}(j);
              else
                 Mp{k}(i,j)=s{k}(D{k})-s{k}(j);
              end;      
           end;
        end;

        K{k}=((M{k}'*M{k}+lambda{k}*eye(Nu{k}))^-1)*M{k}';
        Ku{k}=K{k}(1,:)*Mp{k};
        Ke{k}=sum(K{k}(1,:));
    end

    %generacja macierzy





    %przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow



    %glowna petla

    du = cell(1,reg);

    for k=21:n 
       Y(k)=symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2)); 

       e=Yzad(k)-Y(k); %uchyb
       err = err + e^2;
       U(k)=U(k-1);
       for i = 1:reg
            du{i}=Ke{i}*e-Ku{i}*dup{i}'; %regulator
            for n=D{i}-1:-1:2
                dup{i}(n)=dup{i}(n-1);
            end
            dup{i}(1)=du{i};
            mi{i} = trapmf(Y(k),trapy(i,:));
            U(k) = U(k) + mi{i}*dup{i}(1);
       end



       if U(k)>1 %ograniczenia na min/max sygnalu sterowania
           U(k) = 1;
       end
       if U(k)<-1
           U(k) = -1;
       end

    end

    err;
end

function y = stat_val(u)
    load stat.mat
    if (u>=-1 && u<=1)
        y = Ys( int8((u+1)*50 + 1) );
    end
end
