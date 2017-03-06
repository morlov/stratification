function application_stratify

clear all;

addpath '../test';
addpath '../utils';
addpath '../algs';
load '../datasets/data_app_criteria.mat' data
load '../datasets/voice_app_criteria.mat' voice


nstrat = 3;
nrep = 50;

data_zscore = znorm(data);
data_minmax = datanorm(data);


voice_zscore = znorm(voice);
voice_minmax = datanorm(voice);

% [data_w, data_idx, ~] = linStratQPR(data, nstrat, nrep);
% data_w
% sum(data_idx==3)
% sum(data_idx==2)
% sum(data_idx==1)

[data_zscore_w, data_zscore_idx, ~] = linStratQPM(data_zscore, nstrat, nrep);
data_zscore_w
sum(data_zscore_idx==3)/length(data_zscore_idx)
sum(data_zscore_idx==2)/length(data_zscore_idx)
sum(data_zscore_idx==1)/length(data_zscore_idx)
data_zscore_idx = 4 - data_zscore_idx;

%disp_strata(data_zscore, data_zscore_idx, 'data')

% [data_minmax_w, data_minmax_idx, ~] = linStratQPM(data_minmax, nstrat, nrep);
% data_minmax_w
% sum(data_minmax_idx==3)/length(data_zscore_idx)
% sum(data_minmax_idx==2)/length(data_zscore_idx)
% sum(data_minmax_idx==1)/length(data_zscore_idx)

% [voice_w, voice_idx, ~] = linStratQPR(voice, nstrat, nrep);
% voice_w
% sum(voice_idx==3)
% sum(voice_idx==2)
% sum(voice_idx==1)


[voice_zscore_w, voice_zscore_idx, ~] = linStratQPM(voice_zscore, nstrat, nrep);
voice_zscore_w
sum(voice_zscore_idx==3)/length(voice_zscore_idx)
sum(voice_zscore_idx==2)/length(voice_zscore_idx)
sum(voice_zscore_idx==1)/length(voice_zscore_idx)
voice_zscore_idx = 4 - voice_zscore_idx;
% [voice_minmax_w, voice_minmax_idx, ~] = linStratQPM(voice_minmax, nstrat, nrep);
% voice_minmax_w
% sum(voice_minmax_idx==3)/length(voice_zscore_idx)
% sum(voice_minmax_idx==2)/length(voice_zscore_idx)
% sum(voice_minmax_idx==1)/length(voice_zscore_idx)
disp_strata(voice_zscore, voice_zscore_idx, 'voice')
end