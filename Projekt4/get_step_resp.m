function s = get_step_resp(from, to)
%     from = -0.9; to = 1;
%     if exist(strcat('steps/step_',num2str(from),'_',num2str(to),'.mat'),'file')
%         load(strcat('steps/step_',num2str(from),'_',num2str(to),'.mat'));
%     else
        U(1:200) = from;
        U(20:200) = to;
        Y(1:200) = stat_val(from);
        for k = 12:200
            Y(k) = symulacja_obiektu4y(U(k-5), U(k-6), Y(k-1), Y(k-2));
        end
        s(1:180) = (Y(21:200)-stat_val(from))/(to-from);
%         save(strcat('steps/step_',num2str(from),'_',num2str(to),'.mat'),'s');

%     end

end


function y = stat_val(u)
    load stat.mat
    if (u>=-1 && u<=1)
        y = Ys( int8((u+1)*50 + 1) );
    end
end