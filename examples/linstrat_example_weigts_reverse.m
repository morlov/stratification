function linstrat_example_weigts_reverse

clc;

% Test algorithms on synthetic data for linear strata
addpath '../utils';
addpath '../algs';
addpath '../test';

nstrat = 3;
nrep = 30;

data1 = [0 1; 0 2; 0 3; 10 0; 20 0; 30 0];
data2 = [0 80; 0 90; 0 100; 10 0; 20 0; 30 0];   
data3 = [0 10; 0 20; 0 30; 10 0; 20 0; 30 0];
data4 = [0 1; 1 0; 1 1; 1 2; 2 1; 2 0; 0 2]

%[w1, index1, c1] = linStratQP(data1, nstrat, nrep)
% [w2, index2, c2] = linStratQP(data2, nstrat, nrep)
%[w3, index3, c3] = linStratQP(data3, nstrat, nrep)
[w4, index4, c4] = linStratQPM(data4, nstrat, nrep)

% disp_strata(data1, index1, 'Data1');
% disp_strata(data2, index2, 'Data2');
% disp_strata(data3, index3, 'Data3');
disp_strata(data4, index4, 'Data4');

end