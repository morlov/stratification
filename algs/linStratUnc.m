function  [w,index,c]  = linStratUnc(data, nstrat, nrep)
% Linear stratification using quadratic programming
% Inpout:
% data - dataset to be stratified
% nstrat - desired number of strata
%
% Output:
% w - criteria weights
% index - strata inicies
% c - strata centres
% =====================================================================

cost_best = 1e6;
for i = 1:nrep
    [w_temp,index_temp,c_temp, cost]  = optimize(data, nstrat);
    if cost < cost_best
        cost_best = cost;
        w = w_temp;
        index = index_temp;
        c = c_temp;
        % fprintf(' linStratQP: cost %f at replicate %d \n', cost, i);
    end
    w = w./sum(w);
    % fprintf(' linStratQP: cost %f at replicate %d \n', cost, i);
end

end

function  [w,index,c, cost]  = optimize(data, nstrat)

% Initializes dimention and size
nsample = size(data,1);
dim = size(data,2);

% Initializes weights
w = initWeight(dim);

% Initialize strata centers
r = data*w';
c = linspace(min(r), max(r), nstrat)'; 
% c =sort(min(r) + (max(r)- min(r)) * rand(1,nstrat));
% Index and partition initialization
index = randi(nstrat, nsample,1);
S = zeros(nsample,nstrat);

% Set algoritm params
dst = 1;
tol = 1e-9;
maxiter = 100;
miniter = 5;
iter = 1;
progress = zeros(maxiter,1);
prew = 0;
while (dst > tol) || (iter < miniter)
    
     % 1. Given w and c find index of strata
    tt = abs(repmat(c', nsample, 1) - repmat(data*w',1,nstrat));
    [~, index] = min(tt,[],2);
    for i = 1:nstrat
        S(:,i) = (index == i);
    end
             
    % 2. Given S find w and c
    
    Y = data'*S;
    % D = diag(1 ./ diag(S'*S));
    D = diag(S'*S);
    D(D   ~= 0) = 1./D(D   ~= 0);
    D = diag(D);
    B = Y*D*Y' - data'*data;
    [V,~] = eig(B);
    w = V(:,dim)';
    % 2. Given w and index find centers
    c = D*S'*(data*w');
   
    % Checks convergence
    e = (data*w' - S*c);
    cost =  e'*e;
    dst = abs(cost - prew);
    prew = cost;
    progress(iter) = cost;
    
    % Displays progress
%     if ~mod(iter,100)
%         fprintf(' Convergance rate at %d iteration cost = %f. \n', iter, cost);
%     end
     iter = iter + 1;
    if (iter > maxiter)
        % fprintf(' Linstrat failed to converege in %d iterations. \n', maxiter);
        break;
    end
end
% figure;
% plot(progress(1:miniter-1));
% fprintf(' Linstrat convereged in %d iterations. \n', iter);
end