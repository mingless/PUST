

n = 1000; %dlugosc symulacji

D=350;      %parametry regulatora
N=350; Nu=350; lambda=1;

U1pp = 30;
U2pp = 35;
Y1pp = 35.31;
Y2pp = 35.94;


s11 = fscanf(fopen('s11', 'r'), '%f', [1 inf]);
s12 = fscanf(fopen('s12', 'r'), '%f', [1 inf]);
fclose('all');
S = zeros(2,2,350);
S(1,1,1:end)=s11;
S(2,2,1:end)=s11;
S(1,2,1:end)=s12;
S(2,1,1:end)=s12;

nu = length(S(1,:,1));
ny = length(S(:,1,1));


M = zeros(N*ny,Nu*nu);

for i=1:N
  for j=1:Nu
      if (i>=j)
            M(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i-j+1);
      end; %znajduje miejsce na odpowiednie S_n (ny x nu) i je tam wpisuje
  end;
end;

Mp=zeros(N*ny,(D-1)*nu);
for i=1:N
  for j=1:D-1
      if i+j<=D
            Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,i+j)-S(1:ny,1:nu,j);
      else
          Mp(1+(i-1)*ny:i*ny, 1+(j-1)*nu:j*nu)=S(1:ny,1:nu,D)-S(1:ny,1:nu,j);
      end; %analogicznie do macierzy M
  end;
end;

%przeksztalcanie wyliczonych macierzy do potrzebnych nam parametrow dla
%zmniejszenia wymaganych obliczen

K=((M'*M+lambda*eye(Nu*nu))^-1)*M';
Ku=K(1:nu,:)*Mp; %pierwsze dwa rzedy K * Mp
Ke = zeros(nu,ny);
for j=1:ny %nu wierszy zawierajacych ny sum z K dla poszczegolnych wyjsc
    Ke(:,j)=sum(K(1:nu,j:ny:end),2);
end


%print
file = fopen('params.txt','w');
fprintf(file,'Ke11 := %f;\n',Ke(1,1));
fprintf(file,'Ke12 := %f;\n',Ke(1,2));
fprintf(file,'Ke21 := %f;\n',Ke(2,1));
fprintf(file,'Ke22 := %f;\n',Ke(2,2));

for i = 0:size(Ku,2)-1
    fprintf(file, 'Ku1[%d] := %f;\n',i,Ku(1,i+1));
    fprintf(file, 'Ku2[%d] := %f;\n',i,Ku(2,i+1));
end
fclose(file);

%base for DMC in GX3. Cannot check the previous code.

% du1 := Ke11 * e1 + Ke21 * e2;
% du2 := Ke12 * e1 + Ke22 * e2;
% FOR it := 0 TO D-2 BY 1 DO
%     du1 := du1 - Ku1[it] * dup1[it];
%     du2 := du2 - Ku2[it] * dup2[it];
% END_FOR;
% 
% FOR it := D-2 TO 1 BY -1 DO
%     dup1[it] := dup1[it-1];
%     dup2[it] := dup2[it-1];
% END_FOR;
% 
% dup1[0] = du1;
% dup2[0] = du2;










