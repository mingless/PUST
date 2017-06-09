function err = DMC_err(param)

load('step_responses.mat');

nu = length(S(1,:,1));
ny = length(S(:,1,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%trajektorie zadane i parametry - do ustawienia

n = 1200; %dlugosc symulacji

D=120;      %parametry regulatora
N=120; Nu=120;
lambda(1:4) = param(1:4);
psi(1:3) = param(5:7);
% lambda(1) = 1; lambda(2) = 0.8; lambda(3) = 0.6; lambda(4) = 0.8;
% psi(1) = 1; psi(2) = 1; psi(3) = 1;

Yzad(1:n*ny,1) = 0;

%format wpisywania Yzad: Yzad(NY+K*ny:ny:n*ny) = YS
%gdzie NY - numer wyjscia, K - czas skoku, YS - wartosc skoku

Yzad(1+20*ny:ny:n*ny) = 1.4; 
Yzad(1+600*ny:ny:n*ny)= 0.2;  
Yzad(1+1000*ny:ny:n*ny)= -0.8; 

Yzad(2+150*ny:ny:n*ny)= -0.3;  
Yzad(2+400*ny:ny:n*ny) = 0.9; 
Yzad(2+800*ny:ny:n*ny)= -0.7; 

Yzad(3+200*ny:ny:n*ny)= 1.2;  
Yzad(3+500*ny:ny:n*ny)= -0.8;  
Yzad(3+700*ny:ny:n*ny)= 1.6;
Yzad(3+900*ny:ny:n*ny)= -1.3;  

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y(1:n*ny,1) = 0; %inicjalizacje pionowych wektorow
U(1:n*nu,1) = 0;
err = 0;

%inicjalizacja macierzy dUp


dup(1:(D-1)*nu,1)=0;

%generacja macierzy

M = zeros(N*ny,Nu*nu);

for i=1:N
   for j=1:Nu
      if (i>=j)
         M(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i-j+1);
      end %znajduje miejsce na odpowiednie S_n (ny x nu) i je tam wpisuje
   end
end

Mp=zeros(N*ny,(D-1)*nu);
for i=1:N
   for j=1:D-1
      if i+j<=D
         Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i+j)-S(1:ny,1:nu,j);
      else
         Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,D)-S(1:ny,1:nu,j);
      end %analogicznie do macierzy M
   end
end

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow dla
%zmniejszenia wymaganych obliczen

Lambda = diag(repmat(lambda,1,Nu));
Psi = diag(repmat(psi,1,N));

% K=((M'*M+lambda*eye(Nu*nu))^-1)*M';
K=((M'*Psi*M+Lambda)^-1)*M'*Psi;
Ku=K(1:nu,:)*Mp; %pierwsze dwa rzedy K * Mp
Ke = zeros(nu,ny);
for j=1:ny %nu wierszy zawierajacych ny sum z K dla poszczegolnych wyjsc
    Ke(:,j)=sum(K(1:nu,j:ny:end),2);
end
    

%glowna petla

for i=21:n
   %zamiana indeksowania: Y_N(i-K)=>Y(N+(i-K-1)*ny); U_N(i-K)=>Y(N+(i-K-1)*nu); 
   [Y(1+(i-1)*ny), Y(2+(i-1)*ny), Y(3+(i-1)*ny)] = symulacja_obiektu4(...
       U(1+(i-2)*nu),U(1+(i-3)*nu),U(1+(i-4)*nu),U(1+(i-5)*nu),...
       U(2+(i-2)*nu),U(2+(i-3)*nu),U(2+(i-4)*nu),U(2+(i-5)*nu),...
       U(3+(i-2)*nu),U(3+(i-3)*nu),U(3+(i-4)*nu),U(3+(i-5)*nu),...
       U(4+(i-2)*nu),U(4+(i-3)*nu),U(4+(i-4)*nu),U(4+(i-5)*nu),...
       Y(1+(i-2)*ny),Y(1+(i-3)*ny),Y(1+(i-4)*ny),Y(1+(i-5)*ny),...
       Y(2+(i-2)*ny),Y(2+(i-3)*ny),Y(2+(i-4)*ny),Y(2+(i-5)*ny),...
       Y(3+(i-2)*ny),Y(3+(i-3)*ny),Y(3+(i-4)*ny),Y(3+(i-5)*ny));

   
   e=Yzad(1+(i-1)*ny:i*ny)-Y(1+(i-1)*ny:i*ny); %uchyb
   err = err + sum(e.^2);
   
   du=Ke*e-Ku*dup; %regulator
   
   
   for ni=D-1:-1:2 %przesuniecie dup
      dup(1+(ni-1)*nu:ni*nu)=dup(1+(ni-2)*nu:(ni-1)*nu);
      
   end
   dup(1:nu)=du;
   
   U(1+(i-1)*nu:i*nu)=U(1+(i-2)*nu:(i-1)*nu)+dup(1:nu); %wyznaczenie nowego
                                                        %sterowania
end

end