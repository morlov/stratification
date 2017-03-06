function disp_strata(data, index, ttl)
% data = datanorm(data);
nstrat = numel(unique(index));
color = ['g', 'b', 'r', 'k'];
marker = ['o', '*', 's', 'x'];
% marker = ['.', '.', '.', '.'];
cla;
hold on;
grid on;
title(ttl);
%showaxes on
%set(gca,'XTick',[0 1],'YTick',[0 1]);
if size(data, 2) == 2
    xmax = max(data(:,1)) + 0.5; xmin = min(data(:,1)) - 0.5;
    ymax = max(data(:,2)) + 0.5; ymin = min(data(:,2)) - 0.5;
    axis([xmin xmax ymin ymax]);
    for i =1:nstrat
        ind = (index == i);
        x = data(ind,1);
        y = data(ind,2);
        plot(x,y,[marker(i),color(i)], 'MarkerSize', 12);
        % hold on;
    end
elseif size(data, 2) == 3
    for i =1:nstrat
        ind = (index == i);
        x = data(ind,1);
        y = data(ind,2);
        z = data(ind,3);
        plot3(x,y,z, [marker(i),color(i)], 'MarkerSize', 12);
    end
end
%hold off;
end