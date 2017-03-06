clc;
clear all;
format short;
% Test algorithms on real data
addpath '../utils';
addpath '../algs';
addpath '../datasets';

final_table = zeros(30,11);

nstrat = 3;

% Load, prepocess and stratify taxonomy data
load ../datasets/scientist_taxonomy.mat tax

tax = 4 - tax;
tax = round(datanorm(tax) * 100);
table(:,5) = tax;
[~,tax_idx,~ ] = linStratQP(tax, nstrat, 100);
tax_idx = nstrat + 1 - tax_idx;

% Load, preprocess and stratify citation data
load ../datasets/scientist_citation_2014.mat cit
% cit=[cit(:,1)./cit(:,2) cit(:,3)];
cit = round(datanorm(cit) * 100);
[linstrat_cit_w,linstrat_cit_idx,~ ] = linStratQP(cit, nstrat, 50);
[pca_cit_w,pca_cit_idx,~ ] =  pcaStrat(cit, nstrat, 50);
pca_cit_w = pca_cit_w ./ sum(pca_cit_w);
linstrat_cit_idx = nstrat + 1 - linstrat_cit_idx;
pca_cit_idx = nstrat + 1 - pca_cit_idx;

% Load, preprocess and stratify merits data
load ../datasets/scientist_merit.mat mer
mer = round(datanorm(mer) * 100);
[linstrat_mer_w,linstrat_mer_idx,~ ] = linStratQP(mer, nstrat, 50);
[pca_mer_w,pca_mer_idx,~ ] =  pcaStrat(mer, nstrat, 50);
pca_mer_w = pca_mer_w ./ sum(pca_mer_w);
linstrat_mer_idx = nstrat + 1 - linstrat_mer_idx;
pca_mer_idx = nstrat + 1 - pca_mer_idx;

% Citations + merits
cit_mer = [cit mer];
[linstrat_cit_mer_w,linstrat_cit_mer_idx,~ ] = linStratQP(cit_mer, nstrat, 50);
[pca_cit_mer_w,pca_cit_mer_idx,~ ] =  pcaStrat(cit_mer, nstrat, 50);
pca_cit_mer_w = pca_cit_mer_w ./ sum(pca_cit_mer_w);
linstrat_cit_mer_idx = nstrat + 1 - linstrat_cit_mer_idx;
pca_cit_mer_idx = nstrat + 1 - pca_cit_mer_idx;


% Compare stratifications with cotigency table for linstrat
linstrat_tax_mer_contigency = crosstab(tax_idx, linstrat_mer_idx);
linstrat_tax_cit_contigency = crosstab(tax_idx, linstrat_cit_idx);
linstrat_mer_cit_contigency = crosstab(linstrat_mer_idx, linstrat_cit_idx);
linstrat_tax_citmer_contigency = crosstab(tax_idx, linstrat_cit_mer_idx);

% Compare stratifications with cotigency table for pca
pca_tax_mer_contigency = crosstab(tax_idx, pca_mer_idx);
pca_tax_cit_contigency = crosstab(tax_idx, pca_cit_idx);
pca_mer_cit_contigency = crosstab(pca_mer_idx, pca_cit_idx);
pca_tax_citmer_contigency = crosstab(tax_idx, pca_cit_mer_idx);

% Compute kemeny-snell distance
idx = [tax_idx linstrat_cit_idx linstrat_mer_idx pca_cit_idx pca_mer_idx];
ks_distance = kemeny_snell_distance(idx, idx);

% Concatenate all rankings and compute spearman correlation

linstrat_cit_rank = cit * linstrat_cit_w';
table(:,1) = linstrat_cit_rank;
linstrat_mer_rank = mer * linstrat_mer_w';
table(:,3) = linstrat_mer_rank;
pca_cit_rank = cit * pca_cit_w';
pca_mer_rank = mer * pca_mer_w';
strat = [linstrat_cit_rank pca_cit_rank linstrat_mer_rank pca_mer_rank];
strat = round(datanorm(strat)*100);

ranks = [tax cit mer strat];
correlations = corr(ranks, 'type','Spearman');

% Fit linear model of data
% mdl_cit = fitlm(cit,tax);
% mdl_mer = fitlm(mer,tax);

% Final taxonomy over aggreagted criteria
linstrat_fin_criteria = [linstrat_cit_rank, linstrat_mer_rank, tax];
linstrat_fin_criteria = datanorm(linstrat_fin_criteria) * 100;
table(:,[2,4,5]) = linstrat_fin_criteria; 
[linstrat_fin_w,linstrat_fin_idx,~ ] = linStratQP(linstrat_fin_criteria, nstrat, 50);
linstrat_fin_r = linstrat_fin_criteria * linstrat_fin_w';
linstrat_fin_r = round(datanorm(linstrat_fin_r)*100);

table(:,6) =  linstrat_fin_criteria * linstrat_fin_w';
table(:,7) = datanorm(table(:,6)) * 100;
table(:,8:11)  = [linstrat_cit_idx, linstrat_mer_idx, tax_idx, linstrat_fin_idx];
linstrat_fin_idx = nstrat + 1 - linstrat_fin_idx;
clc;

% Stratification over all criteria
all_criteria = [cit(:,1) mer(:,2) tax];
[linstrat_all_w, linstrat_all_idx, ~ ] = linStratQP(all_criteria, nstrat, 100);
linstrat_all_idx = nstrat + 1 - linstrat_all_idx;
clc;

