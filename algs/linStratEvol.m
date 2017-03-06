function [w, index,c] = linStratEvol(data, nstrat, nrep)
populsize = 300;
niter = 100;
param = 0.01;
w = evolmin(data,nstrat,niter,populsize,param);
r = data*w';
[index, c] = best_stratify(r, nstrat, nrep);
end