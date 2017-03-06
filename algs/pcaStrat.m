function [w,index,c] = pcaStrat(Y, nstrat, nrep)

w = pca(Y, 'Centered',false,'NumComponents',1);
w = (w./sum(w))';
r = Y*w';
[index, c] = best_stratify(r, nstrat, nrep);

if ~exist('index','var')
    disp('Something happend ...');
end
end