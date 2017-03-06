function country_stratification
%clc;
clear all;
format short;
% Test algorithms on real data
addpath '../utils';
addpath '../algs';
load '../datasets/countries.mat' countries

% countries = countries(:, [4, 5, 6]); %%%%

[n m] = size(countries);

% Stratify each criteria separately and compare stratifications
countries_strat = zeros(n,m);
nstrat = 3;
nrep = 100;
countries = datanorm(countries);
% countries = znorm(countries);

for i = 1:m
    countries_strat(:,i) = best_stratify(countries(:,i), nstrat, nrep);
end

% dist_criteria_ranking= hamming_distance(journals, journals);
% disp(dist_criteria_ranking)
%dist_criteria_criteria_strat = kemeny_snell_distance(countries_strat, countries_strat);
% disp(dist_criteria_criteria_strat)

fprintf('\n'); 
algs = {'linStratQP','linStratEvol','bordaStrat','linprogStrat','authorityStrat', 'paretoStrat'};
% algs = {'linStratQP', 'neuroStrat'};
nalgs = length(algs);
alg_strat = zeros(n, nalgs);
% Run tests
for j = 1:nalgs
    [~, alg_strat(:,j) ] = feval(algs{j}, countries, nstrat, nrep);
end
dist_criteria_algs_strat = kemeny_snell_distance(countries_strat, alg_strat);
% disp(dist_criteria_algs_strat)
fprintf('\n');
disp(sum(dist_criteria_algs_strat, 1)/m)
fprintf('\n');
dist_algs_algs_strat = kemeny_snell_distance(alg_strat, alg_strat);
disp(dist_algs_algs_strat)
fprintf('\n');
I = alg_strat(:,1);
find(I == 3)
find(I == 2)
find(I == 1)
[w, ~, ~] = linStratQP(countries, nstrat, nrep);
disp(w)
end