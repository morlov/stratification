function testStrat
addpath '..\utils';
addpath '..\algs';
% Some code for testin stratififcation utilities
clc;
% =====================================================================
% Initialize parameters
%w = initWeight(8);
w = [0.5 0.5];
c = [0.3 0.5 0.8];
theta = [1 1 1]/3;
sigma = [0.01 0.01 0.01];
nsample = 300;
nstrat = size(c,2);
nrep = 25;
[data index] = stratGen(w, c, theta, sigma, nsample);
% data = dataNormalize(data);
dispStrata(data, index);

% load 'C:\Users\m.orlov\Dropbox\hse\phd\stratification_code\datasets\alco.mat' alco
% data = alco;
% nstrat = 3;
% nrep = 100;
% [w, index_est, c]  = linStratEvol(data, nstrat,nrep);
% disp(w)
% disp(c)
% [w, index_est, c]  = linStratQP(data, nstrat,nrep);
% disp(w)
% disp(c)
% [w, ~, c]  = authorityStrat(data, nstrat,nrep);
% disp(w)
% disp(c)

%     accuracy= double(sum(index_est == index))/nsample;
%     disp(accuracy);
% runTest;

% =====================================================================
end
% =====================================================================
function runTest
% Sets up data parameters
theta = [1 1 1]/3;
% theta = [0.1806    0.3685    0.4509];
% theta = [0.0280    0.5615    0.4105];
% theta = [0.2792    0.5313    0.1895];

% w = ones(1,5)/5;
c = [0.3 0.5 0.8];
sigma = [0.01 0.01 0.01];
nsample = 100;
nstrat = size(c,2);
% Sets up algorithms parameters
ntest = 30;
nalgs = 6;
algs = {'linStratQP','linStratEvol','neuroStrat','authorityStrat','bordaStrat','linprogStrat'};
accuracy = zeros(ntest, nalgs);
nrep = 50;
% Repeats tests and evaluates accuracy for each algorithm
for i = 1:ntest
    % Generate data    
    w = ones(1,5)/5;%initWeight(10);
    [data index] = stratGen(w, c, theta, sigma, nsample);
    % Runs algotithms
    [~, index_est,~]  = linStratQP(data, nstrat,nrep);
    accuracy(i, 1) = double(sum(index_est == index))/nsample;
    [~, index_est,~]  = linStratEvol(data, nstrat, nrep);
    accuracy(i, 2) = double(sum(index_est == index))/nsample;
    [~, index_est,~]  = neuroStrat(data, nstrat,nrep);
    accuracy(i, 3) = double(sum(index_est == index))/nsample;
    [~,index_est,~] = authorityStrat(data,nstrat,nrep);
    accuracy(i, 4) = double(sum(index_est == index))/nsample;
    [~,index_est] = bordaStrat(data,nstrat,nrep);
    accuracy(i, 5) = double(sum(index_est == index))/nsample;
    [~, index_est,~] = linprogStrat(data, nstrat,nrep);
    accuracy(i, 6) = double(sum(index_est == index))/nsample;
    disp(accuracy(i,:));
    fprintf(' %d test done \n', i);
end
% Compute accuracy statistics
mean_accuracy = mean(accuracy,1);
std_accuracy = std(accuracy,1);
max_accuracy = max(accuracy,[],1);
min_accuracy = min(accuracy,[],1);
% Displays statistic of tests
fprintf('\n Algorithms performance summary: \n');
for i = 1:nalgs
    fprintf(' Algorithm: %s \n', algs{i});
    fprintf(' Mean accuracy: %f \n', mean_accuracy(i));
    fprintf(' Std accuracy: %f \n', std_accuracy(i));
    fprintf(' Min accuracy: %f \n', min_accuracy(i));
    fprintf(' Max accuracy: %f \n', max_accuracy(i));
    fprintf(' ============================== \n');
end
end

