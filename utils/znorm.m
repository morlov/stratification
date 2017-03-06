function z = znorm(x)
 z = (x -  repmat(mean(x, 1), size(x, 1),1))./repmat(std(x,1,1),size(x, 1),1) ;
% z = x ./ repmat(std(x,1,1),length(x),1) ;