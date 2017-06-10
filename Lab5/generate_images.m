files = dir('*.mat');
for file = files'
    clearvars -except files file
    load(file.name);
    if ~exist('y1','var')
        continue
    end
%     strcat(file.name(1:end-4),'.tex')
    figure('Position',  [403 0 620 725]);
    subplot('Position', [0.1 0.069 0.8 0.0855]); %62 at 50
    stairs(u2);
    decimal_comma(gca, 'XY');
    xlabel('$k$');
    ylabel('$u_2$');
    subplot('Position', [0.1 0.2138 0.8 0.0855]); %62 at 155
    stairs(u1);
    decimal_comma(gca, 'XY');
    ylabel('$u_1$');
    subplot('Position', [0.1 0.3586 0.8 0.2759]); %200 at 260
    plot(y2);
    hold on;
    if exist('yzad2','var')
        plot(yzad2,':');
    end
    decimal_comma(gca, 'XY');
    ylabel('$y_2$');
    subplot('Position', [0.1 0.6897 0.8 0.2759]); %200 at 500
    plot(y1);
    hold on;
    if exist('yzad1','var')
        plot(yzad1,':');
    end
    decimal_comma(gca, 'XY');
    ylabel('$y_1$');
     matlab2tikz(strcat('../sprawozdanie/Lab5/im/',file.name(1:end-4),'.tex'),...
             'encoding','UTF-8','parseStrings',false);
end
close all;