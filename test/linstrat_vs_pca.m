function linstrat_vs_pca

clc;
addpath '../utils';
addpath '../algs';

data = [2	0; 0	1; 6	0; 5	0.5; 3	1.5; 1	2.5; 4	2; 2	3];
% data = [0	1; 1	0; 1	3; 2  2; 2	5; 3 4];    

% index = [1 1 2  2 2 2 3 3];
%disp_strata(data, index, 'Strata');

nstrat = 3;
nrep = 25;
[linstrat_w, index_linstart, ~] = linStratQPM(data, nstrat, nrep);
linstrat_r = data*linstrat_w'
linstrat_w
disp_strata(data, index_linstart, 'Strata');

% pca_w = pca(data, 'Centered',false,'NumComponents',1)
% pca_w = (pca_w./sum(pca_w))'
% pca_r = data*pca_w'

[z, mu, c]=svd(data); 
pca_w = -c(:, 1)';
pca_w = pca_w./sum(pca_w)
pca_r = data*pca_w'
mu=mu(1,1) 
alpha = 1./sum(pca_w);
100 - 100*mu(1,1)^2/sum(sum(data.*data))




end