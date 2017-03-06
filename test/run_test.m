function run_test(w, c, theta, sigma, phi, nsample, nstrat, ntrial)


% Sets up algorithms parameters
% algs = {'linStratQP','linStratEvol','neuroStrat','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat', 'kmeansStrat'};
% algs = {'linStratQP','linStratEvol','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat', 'kmeansStrat'};
algs = {'linStratQP','linStratEvol','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat'};
% algs = {'linStratQPR', 'linStratQP'};
% algs = { 'linStratQP'};
% algs = {'linStratQP', 'pcaStrat'};
nalgs = length(algs);
nrep = 25;
accuracy = zeros(nalgs, ntrial);

% Run tests
for i = 1:ntrial
fprintf('*');
[data, index] = stratgen(w, c, theta, sigma, phi, nsample);
for j = 1:nalgs
    [~, index_est] = feval(algs{j}, data, nstrat, nrep);
    accuracy(j, i) = double(sum(index_est == index))/nsample;
end
end

% Displays test results
fprintf('\n Algorithms performance summary: \n');
for i = 1:nalgs
    if ntrial == 1
        fprintf(' Algorithm: %s Accuracy = %f \n', algs{i}, accuracy(i));
    else
        fprintf(' Algorithm: %s Mean accuracy = %f, std = %f \n', algs{i}, mean(accuracy(i,:)), std(accuracy(i,:)));
    end
end
fprintf(' ============================== \n');
end