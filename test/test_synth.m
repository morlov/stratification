function test_synth
clc;
clear all;

% Test algorithms on synthetic data for linear strata
addpath '../utils';
addpath '../algs';

% Set parameters
c = [0.3 0.5 0.8];

w = [0.20, 0.20, 0.20, 0.20, 0.20;...
        0.05, 0.10, 0.25, 0.30, 0.30;...
        0.05, 0.05, 0.10, 0.30, 0.50;...
        0.05, 0.05, 0.05, 0.25, 0.60;...
        0.05, 0.05, 0.05, 0.05, 0.80];

theta = [1/3, 1/3, 1/3;...
              0.50, 0.30, 0.20;...
              0.70, 0.20, 0.10;...
              0.80, 0.15, 0.05];

sigma = [0.01; 0.05; 0.1; 0.2];

phi = [1; 0.01; 0.05; 0.1; 0.5];

nsample = 300;
nstrat = length(c);
ntrial = 10;
dim = [3; 5; 10; 15; 20];

% Test schedule
test1 = 0; 
test2 = 0;
test3 = 1;
test4 = 1;
test5 = 1;
test6 = 1;


% Test 1. Verification of algorithm's weights evaluation
if test1
fprintf('Test 1. Verification of algorithms correctnes for weights evaluation. \n');
fprintf(' =============================================================== \n');
nrep = 25;

fprintf('Check linStratQP with randomly generated weights: \n');
for i = 1:10
    rand_w = initWeight(size(w,2));
    fprintf(['Weigths',num2str(i),': \n']);
    disp(rand_w);
    fprintf('\n');
    data = stratgen(rand_w, c, theta(1,:), sigma(1), phi(1), nsample);
    pred_w = linStratQPM(data, nstrat,nrep);
    disp(pred_w);
    fprintf('\n');
end

end

% Test 2. Varying w and sigma
if test2
fprintf('Test 2. Varying w and sigma and check stratification accuracy. \n');
fprintf(' =============================================================== \n');
for i = 1:size(w,1)
    for j = 1:size(sigma,1)
        data_set_name = ['w', num2str(i), 'theta1', 'sig', num2str(j)];
        fprintf('Dataset %s \n', data_set_name);
        run_test(w(i,:), c, theta(1,:), sigma(j), phi(1), nsample, nstrat, ntrial);
    end
end
end

% Test 3. Varying w and theta
if test3
fprintf('Test 3. Varying w and theta and check stratification accuracy. \n');
fprintf(' =============================================================== \n');
for i = 1:size(w,1)
    for j = 1:size(theta,1)
        data_set_name = ['w', num2str(i), 'theta', num2str(j), 'sig1'];
        fprintf('Dataset %s \n', data_set_name);
        run_test(w(i,:), c, theta(j,:), sigma(1), phi(1), nsample, nstrat, ntrial);
    end
end
end

% Test 4. Varying w and phi
if test4
fprintf('Test 4. Varying w and phi and check stratification accuracy. \n');
fprintf(' =============================================================== \n');
for j = 1:size(phi,1)
    data_set_name = ['w1theta1phi', num2str(j), 'sig1'];
    fprintf('Dataset %s \n', data_set_name);
    run_test(w(1,:), c, theta(1,:), sigma(1), phi(j), nsample, nstrat, ntrial);
end
end

% Test 5. Varying dimensionality
if test5
fprintf('Test 5. Varying dimensionality check stratification accuracy. \n');
fprintf(' =============================================================== \n');
for i = 1:length(dim)
    ww = ones(1, dim(i))/dim(i);
    data_set_name = ['w1theta1sig1dim', num2str(dim(i))];
    fprintf('Dataset %s \n', data_set_name);
    run_test(ww, c, theta(1,:), sigma(1), phi(1), nsample, nstrat, ntrial);
end
end

% Test 6. Varying sample size
if test6
fprintf('Test 6. Varying sample size stratification accuracy. \n');
fprintf(' =============================================================== \n');
dim = 20;
ww = ones(1, dim)/dim;
nsample = [200; 300; 500; 800; 1000];
for i = 1:length(nsample)
    data_set_name = ['w', num2str(1), 'theta', num2str(1), 'sig1dim20nsample', num2str(nsample(i))];
    fprintf('Dataset %s \n', data_set_name);
    run_test(ww, c, theta(1,:), sigma(1), phi(1), nsample(i), nstrat, ntrial);
end
end

end

