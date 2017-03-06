function scientist_stratification
clc;
clear all;
format short;
% Test algorithms on real data
addpath './utils';
addpath './algs';
addpath './datasets';
load 'scientist_citation.mat' Y
ratings = Y;

% countries = countries(:, [4, 5, 6]); %

[n m] = size(ratings);

% Stratify each criteria separately and compare stratifications
cities_strat = zeros(n,m);
nstrat = 3;
nrep = 100;
ratings = datanorm(ratings);
% ratings= znorm(ratings);

for i = 1:m
    cities_strat(:,i) = best_stratify(ratings(:,i), nstrat, nrep);
end

% dist_criteria_ranking= hamming_distance(journals, journals);
% disp(dist_criteria_ranking)
% dist_criteria_criteria_strat = kemeny_snell_distance(countries_strat, countries_strat);
% disp(dist_criteria_criteria_strat)

fprintf('\n'); 
algs = {'linStratQP','linStratEvol','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat'};
% algs = {'linStratQP', 'neuroStrat'};
nalgs = length(algs);
alg_strat = zeros(n, nalgs);
% Run tests
for j = 1:nalgs
    [~, alg_strat(:,j) ] = feval(algs{j}, ratings, nstrat, nrep);
end
dist_criteria_algs_strat = kemeny_snell_distance(cities_strat, alg_strat);
disp(dist_criteria_algs_strat)
fprintf('\n');
disp(sum(dist_criteria_algs_strat, 1)/m)
fprintf('\n');
dist_algs_algs_strat = kemeny_snell_distance(alg_strat, alg_strat);
disp(dist_algs_algs_strat)
fprintf('\n');
I = alg_strat(:,1);
end