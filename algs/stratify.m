function [index c cost] = stratify(r, nstrat)
%--------------------------------------------------------------------------
% при заданном векторе весов w или раннге r находим  
% оптимальные значения центров c и разбиение на группы S
%--------------------------------------------------------------------------

dst = 1;
maxiter = 1000;
iter = 1;
nsample = size(r,1);
S = zeros(nsample, nstrat);
% c = linspace(min(r),max(r),nstrat); %% prvious setting
% c = c + rand(1,size(c,2));
c = sort(min(r) + (max(r) - min(r) )*rand(1,nstrat),'ascend');
cost_prew = 1e9;

while dst > 1e-6
    % 1. Given c find index of strata
    tt = abs(repmat(c, nsample, 1) - repmat(r,1,nstrat));
    [~, index] = min(tt,[],2);
    
    % 2. Given index find c
    for i = 1:nstrat
        S(:,i) = (index == i);
    end
    
    c = (r'*S)./sum(S,1);
      
    iter = iter + 1;
    if (iter > maxiter) 
        break; 
    end
cost = sum((r - S*c').^2);
dst = abs(cost - cost_prew);
cost_prew = cost;
end
% fprintf(' Convereged in %d iterations. \n', iter);
end