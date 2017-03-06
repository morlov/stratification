function  [w,index,c]  = neuroStrat(data, nstrat, nrep)

cost_best = 1e6;
for i = 1:nrep
    [w_temp,index_temp,c_temp,cost]  = optimize(data, nstrat);
    if cost < cost_best
        cost_best = cost;
        w = w_temp;
        index = index_temp;
        c = c_temp;
        % fprintf(' neuroStrat: cost %f at replicate %d \n', cost_best, i);
    end 
end

end
% =====================================================================
function [w, index, c, cost] = optimize(data, nstrat)
% Set some parameters
niter = 1000; 
dim = size(data,2);
learning_rate = [0.15/dim, 0.1, 0.1];
nsample = size(data,1);
% Random initialization
w = initWeight(dim);
c = sort(rand(1,nstrat), 'ascend');
b = (c(2:end) - c(1:end-1))/2;
% b = cumsum(rand(1,nstrat-1));
% gradchecker(data, w, c, b)
loss = zeros(1,niter);
% batchsize = 5;
% index = randi(nsample, niter, batchsize);
% Does optimization, finds optimal w, c and b
for i = 1:niter
    % idx = index(i,:);
    [loss(i) grad_w grad_c grad_b] = costfun(data, w, c, b);
    w = w - learning_rate(1)*grad_w;
    c = c - learning_rate(2)*grad_c;
    b = b - learning_rate(3)*grad_b;
    %   if ~mod(i,100)
    %       fprintf(' Loss = %f at iteration %d \n',loss(i),i);
    %   end
end
% plot(loss);
cost = min(loss);
if abs(sum(w) - 1)^2 > 1e-2
    warning('Weights did not converge to unity!');
end
% Converts parapeter c to the level reprersentation
c = cumsum(c);
% Finds incices of strata
S = abs(repmat(c, nsample, 1) - repmat(data*w',1,nstrat));
[~, index] = min(S,[],2);
end
% =====================================================================

% Sigmoid function
function ret = sigmoid(z)
ret = 1./(1 + exp(-100*z));
end

% Gradient of sigmoid
function ret = sigmoid_grad(z)
ret = 100 * sigmoid(z).*(1 - sigmoid(z));
end

% Partition function
function ret = partfun(z, c, b)
p = size(b,2);
n = size(z,1);
ret =[ones(n,1) sigmoid(repmat(z,1,p) - repmat(b,n,1))]*c';
end

% Gradient of partition function by w
function ret = partfun_grad(z, c, b)
p = size(b,2);
n = size(z,1);
ret = sigmoid_grad(repmat(z,1,p) - repmat(b,n,1))*c(2:end)';
end

% Computes loss function and gradient of loss on parameters
function [loss grad_w grad_c grad_b] = costfun(X, w, c, b)
r = X*w';
% Propagates forward 
f = (r - partfun(r,c,b));
n = size(f,1);
m = size(w,2);
p = size(b,2);
k = size(c,2);
reg1 = 10; 
reg2 = 0.001;
eps = 1e-12; % 0.01;
% Computes loss
loss = 0.5*sum(f.^2)/n + 0.5*reg1*(sum(w) - 1)^2  - reg2*sum(log(w+eps));
% Computes loss gradient by parameters
grad_w = sum(X.*repmat((1 - partfun_grad(r, c, b)).*f,1,m),1)/n + reg1*(sum(w) - 1) - reg2/1./(w+eps);
temp = repmat(r,1,p) - repmat(b,n,1);
grad_c = -sum([ones(n,1) sigmoid(temp)].*repmat(f,1,k),1)/n;
grad_b = sum(sigmoid_grad(temp).*repmat(f,1,p).*repmat(c(2:end), n, 1),1)/n;
end

% Gradient checker
function gradchecker(X, w, c, b)
eps = 1e-9;
m = size(w,2);
p = size(b,2);
k = size(c,2);
numgrad = zeros(1,m);
perturb = zeros(1,m);
for j = 1:m
    % Set perturbation vector
    perturb(j) = eps;
    loss1 = costfun(X, w -     perturb, c, b);
    loss2 = costfun(X, w +  perturb, c  , b);
    % Compute Numerical Gradient
    numgrad(j) = (loss2 - loss1) / (2*eps);
    perturb(j) = 0;
end
[~,actgrad ,  ~, ~] = costfun(X,w,c,b);
delta = max(abs(numgrad - actgrad));
assert(delta < 1e-4, 'Actual gradient must correspond to numerical!');
fprintf('>> Gradient test passed \n');
end