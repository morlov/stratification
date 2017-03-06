function example

data = [97 56;93 62;100 44;43 100;97 39;60 12;34 20;13 10;0 5;14 0];
index = [3, 3, 3, 3, 3, 2, 2, 1, 1, 1];

nstrat = numel(unique(index));
color = ['g', 'b', 'r', 'k'];
marker = ['o', '*', 's', 'x'];
title('', 'FontSize', 18)
cla;
hold on;
grid off;
box on;
set(gca,'XTick',[0 20 40 60 80 100],'YTick',[0 20 40 60 80 100]);
xlabel('Criterion 1', 'FontSize', 18)
ylabel('Criterion 2', 'FontSize', 18)
margin = 5;
xmax = max(data(:,1)) + margin; xmin = min(data(:,1)) - margin;
ymax = max(data(:,2)) + margin ; ymin = min(data(:,2)) - margin;
axis([xmin xmax ymin ymax]);
for i =1:nstrat
	ind = (index == i);
    x = data(ind,1);
    y = data(ind,2);
%     marker = 'o';
%     color = 'b';
%     plot(x,y,[marker,color], 'MarkerSize', 16, 'linewidth', 1.5);
    plot(x,y,[marker(i),color(i)], 'MarkerSize', 16, 'linewidth', 1.5);
end

end

