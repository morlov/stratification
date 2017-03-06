function example

data = load('./datasets/students_cities.mat');
data = data.data
nstrat = 3;
nrep = 30;
[w, index, c] = linStratQP(data, nstrat, nrep)

nstrat = numel(unique(index));
color = ['g', 'b', 'r', 'k'];
marker = ['o', '*', 's', 'x'];
title('', 'FontSize', 18)
cla;
hold on;
grid off;
box on;
set(gca,'XTick',[0 20 40 60 80 100],'YTick',[0 20 40 60 80 100]);
xlabel('Доступность', 'FontSize', 18)
ylabel('Желательность', 'FontSize', 18)
margin = 5;
xmax = max(data(:,1)) + margin; xmin = min(data(:,1)) - margin;
ymax = max(data(:,2)) + margin ; ymin = min(data(:,2)) - margin;
axis([xmin xmax ymin ymax]);
for i =1:nstrat
	ind = (index == i);
    x = data(ind,1);
    y = data(ind,2);
    plot(x,y,[marker(i),color(i)], 'MarkerSize', 16, 'linewidth', 1.5);
end

end

