function linstrat_vs_pca_disp

clc;
addpath '../utils';
addpath '../algs';

data1 = [1 0;
        0.5 0.5;
        0 1;
        2 0;
        1 1;
        0 2;
        3 0;
        1.5 1.5;
        0 3];
    
index1 = [1 1 1 2 2 2 3 3 3];

data2 = [1 0;
        0.5 0.5;
        0 1;
        2 0;
        1 1;
        0 2;
        0 3;
        1.5 1.5];
    
index2 = [1 1 1 2 2 2 3 3];

% data2 = [1 0;
%         0 1;
%         2 0;
%         0 2;
%         3 0;
%         %0 3
%         ];
%     
% index2 = [1 1 2 2 3];


% data2 = [1 0;
%         0 1;
%         2 0;
%         0 2;
%         3 0;
%         0 3];
% 
%     
% index2 = [1 1 2 2 3 3 ];


data3 = [1 0;
        0 1;
        2 1;
        1 2;
        3 2;
        2 3];
    
index3 = [1 1 2 2 3 3];

data4 = [0 0;
        1 0;
        1 1.5;
        2 1.5;
        2 3;
        3 3];
    
index4 = [1 1 2 2 3 3];

% subplot(2,2,1);
% disp_strata(data1, index1, '(a)');
% 
% subplot(2,2,2);
% disp_strata(data2, index2, '(b)');
% 
% subplot(2,2,3);
% disp_strata(data3, index3, '(c)');
% 
% subplot(2,2,4);
% disp_strata(data4, index4, '(d)');


subplot(1,2,1);
disp_strata(data1, index1, '(Á)');

subplot(1,2,2);
disp_strata(data2, index2, '(Â)');


[linstrat_w1, index] = linStratQP(data1, 3, 25)
linstrat_r1 = data2*linstrat_w1'

[pca_w1, pca_r1, e1] = pca_weights(data1)

[linstrat_w2, ~] = linStratQP(data2, 3, 25)
linstrat_r2 = data2*linstrat_w2'

[pca_w2, pca_r2, e2] = pca_weights(data2)

% [linstrat_w3, ~] = linStratQP(data3, 3, 25);
% linstrat_r3 = data3*linstrat_w3'
% 
% [pca_w3, pca_r3, e3] = pca_weights(data3)
% 
% [linstrat_w4, ~] = linStratQP(data4, 3, 25);
% linstrat_r4 = data4*linstrat_w4'
% 
% [pca_w4, pca_r4, e4] = pca_weights(data4)

end

function [pca_w, pca_r, e] = pca_weights(data)

[~, mu, c]=svd(data); 
pca_w = -c(:, 1)';
pca_w = pca_w./sum(pca_w);
pca_r = (data*pca_w')'
s = std(pca_r)
mu=mu(1,1) ;
e = 100 - 100*mu(1,1)^2/sum(sum(data.*data));
end
