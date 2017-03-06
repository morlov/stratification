function z = maxnorm(x)
z = x ./  repmat(max(x, [], 1),length(x),1) ;