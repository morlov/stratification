function disp_synth_linear
clc;
clear all;

% Test algorithms on synthetic data for linear strata
addpath '..\utils';
addpath '..\algs';

w = [0.5, 0.5;...
        0.8, 0.2;...
        0.2, 0.8];
    
c = [0.3 0.5 0.8];

theta = [0.50, 0.30, 0.20;...
              0.70, 0.20, 0.10;...
              0.80, 0.15, 0.05];

sigma = [0.01; 0.01; 0.03; 0.5];

phi = [0.3; 0.1; 0.5; 1.0];

nsample = 300;
% Display strata with different parameters
% [data, index] = stratgen([0.4 0.3 0.3], c, theta(1,:), 0, phi(2), 1000);
% disp_strata(data, index , '(à)');

% 1. Display different orientations with constant other parameters
[data, index] = stratgen(w(1,:), c, theta(1,:), sigma(1), phi(1), nsample);
subplot(4,3,1); disp_strata(data, index , '(à)');

[data index] = stratgen(w(2,:), c, theta(1,:), sigma(1), phi(1), nsample);
subplot(4,3,2); disp_strata(data, index, '(á)');

[data index] = stratgen(w(3,:), c, theta(1,:), sigma(1), phi(1), nsample);
subplot(4,3,3); disp_strata(data, index, '(â)');

% 2. Display different thickness with constant other parameters
[data index] = stratgen(w(1,:), c, theta(1,:), sigma(2), phi(1), nsample);
subplot(4,3,4); disp_strata(data, index, '(ã)');

[data index] = stratgen(w(1,:), c, theta(1,:), sigma(3), phi(1),nsample);
subplot(4,3,5); disp_strata(data, index, '(ä)');

[data index] = stratgen(w(1,:), c, theta(1,:), sigma(4), phi(1), nsample);
subplot(4,3,6); disp_strata(data, index, '(å)');

% 3. Display different probabilities with constant other parameters
[data index] = stratgen(w(1,:), c, theta(1,:), sigma(1), phi(1), nsample);
subplot(4,3,7); disp_strata(data, index, '(æ)');

[data index] = stratgen(w(1,:), c, theta(2,:), sigma(1), phi(1), nsample);
subplot(4,3,8); disp_strata(data, index, '(ç)');

[data index] = stratgen(w(1,:), c, theta(3,:), sigma(1), phi(1),nsample);
subplot(4,3,9); disp_strata(data, index, '(è)');

% 3. Display different spread with constant other parameters
[data index] = stratgen(w(1,:), c, theta(1,:), sigma(1), phi(2), nsample);
subplot(4,3,10); disp_strata(data, index, '(ê)');

[data index] = stratgen(w(1,:), c, theta(1,:), sigma(1), phi(3), nsample);
subplot(4,3,11); disp_strata(data, index, '(ë)');

[data index] = stratgen(w(1,:), c, theta(1,:), sigma(1), phi(4), nsample);
subplot(4,3,12); disp_strata(data, index, '(ì)');

end