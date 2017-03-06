function linstrat_example_weigts_reverse

clc;

% Test algorithms on synthetic data for linear strata
addpath '../utils';
addpath '../algs';

nstrat = 3;
nrep = 50;

data1 = [0 1; 0 2; 0 3; 10 0; 20 0; 30 0];
data2 = [0 80; 0 90; 0 100; 10 0; 20 0; 30 0];   

[w1, index1, c1] = linStratQP(data1, nstrat, nrep)

[w2, index2, c2] = linStratQP(data2, nstrat, nrep)


disp_strata(data1, index1, 'Data1');
disp_strata(data2, index2, 'Data2');

end