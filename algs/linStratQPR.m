function  [w,index,c]  = linStratQPR(data, nstrat, nrep)
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
    % fprintf(' linStratQP: cost %f at replicate %d \n', cost, i);
end
% disp(w)
end

function  [w,index,c, cost]  = optimize(data, nstrat)

% Initializes dimention and size
nsample = size(data,1);
dim = size(data,2);

% Initializes weights
w = initWeight(dim);

% Initialize strata centers
r = data*w';
c = linspace(min(r), max(r), nstrat); %  + 0.01*randn(1,nstrat);
% c =cumsum(min(r) + (max(r)- min(r)) * rand(1,nstrat));
% Index and partition initialization
index = zeros(nsample,1);
S = zeros(nsample,nstrat);

% Set algoritm params
dst = 1;
tol = 1e-6;
maxiter = 50;
miniter = 5;
iter = 1;
progress = zeros(maxiter,1);
prew = 0;
while (dst > tol) || (iter < miniter)
    
    % 1. Given w and c find index of strata
    tt = abs(repmat(c, nsample, 1) - repmat(data*w',1,nstrat));
    [~, index] = min(tt,[],2);
    
    % 2. Given w and index find centers
    for i = 1:nstrat
        S(:,i) = (index == i);
    end
     
    c = ((w*data')*S)./sum(S,1);
    if isnan(sum(c))
        c = linspace(min(r), max(r), nstrat) + 0.01*randn(1,nstrat);
    end
        
    % 3. Given c and index solve qp task and find optimal weights
    X = data - repmat(S*c',1,dim);
    % H = X'*X;
    reg = 1000.;
    H = X'*X + reg * diag(ones(dim, 1)) ; % Regularization
    f = zeros(dim,1);
    A = -diag(ones(1,dim));
    b = zeros(dim,1);
    Aeq = ones(1,dim);
    beq = 1;
    % opts = optimset('Algorithm','interior-point-convex','Display','off');
    opts = optimset('Algorithm','interior-point-convex','Display','off','Largescale','off');
    
    w = quadprog(H,f,A,b,Aeq,beq,[],[],[],opts);
    w = w';
    
    % Checks convergence
    e = (data*w' - S*c');
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