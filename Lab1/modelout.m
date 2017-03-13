function Ymod = modelout(data, b, delay )
Ymod = zeros(length(data),1);

delay = delay+1;

for i = delay+2:length(data)
    U = [data(i-delay) data(i-delay-1) Ymod(i-1) Ymod(i-2)];
    Ymod(i) = U * b;
end

end

