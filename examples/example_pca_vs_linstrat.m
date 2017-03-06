function example_pca_vs_linstrat

data = [2 0;0 1;6 0;5 0.5;3 1.5;1 2.5;4 2;2 3];
index = [3, 3, 2, 2, 2, 2, 1, 1];

nstrat = numel(unique(index));
color = ['g', 'b', 'r', 'k'];
marker = ['o', '*', 's', 'x'];
title('PCA using SVD vs Linstrat', 'FontSize', 18)
cla;
hold on;
grid off;
box on;
set(gca,'XTick',[0 1 2 3 4 5 6],'YTick',[0 1 2 3 4]);
xlabel('Критерий 1', 'FontSize', 18)
ylabel('Критерий 2', 'FontSize', 18)
margin = 0.2;
xmax = 6 + margin; xmin = 0 - margin;
ymax = 4 + margin; ymin = 0 - margin;
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