function z = datanorm(x)
z = (x -  repmat(min(x),length(x),1))./repmat(max(x)-min(x),length(x),1) ;
%  z = x ./  repmat(max(x, [], 1),length(x),1) ;