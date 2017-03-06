function journal_stratification
% clc;
clear all;
format short;
% Test algorithms on real data
addpath '../utils';
addpath '../algs';
load '../datasets/journals.mat' journals

journals = journals(:, [1, 2, 8]); 
% journals = journals(:, [3, 6:end]); %%%%
% journals = journals(journals(:, 7) > 90, :);
[n m] = size(journals);

% Stratify each criteria separately and compare stratifications
journal_strat = zeros(n,m);
nstrat = 3;
nrep = 100;
journals = datanorm(journals);
% journals = znorm(journals);
% journals = elnorm(journals,1 );

for i = 1:m
    journal_strat(:,i) = best_stratify(journals(:,i), nstrat, nrep);
end

% dist_criteria_ranking= hamming_distance(journals, journals);
% disp(dist_criteria_ranking)

fprintf('\n'); 
algs = {'linStratQP','linStratEvol','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat'};
nalgs = length(algs);
alg_strat = zeros(n, nalgs);
% Run tests
for j = 1:nalgs
    [~, alg_strat(:,j) ] = feval(algs{j}, journals, nstrat, nrep);
end
dist_criteria_algs_strat = kemeny_snell_distance(journal_strat, alg_strat);
disp(dist_criteria_algs_strat)
fprintf('\n');
disp(sum(dist_criteria_algs_strat, 1)/m)
fprintf('\n');
dist_algs_algs_strat = kemeny_snell_distance(alg_strat, alg_strat);
disp(dist_algs_algs_strat)
fprintf('\n');

[w, ~, ~] = linStratQP(journals, nstrat, nrep);
disp(w)
end
