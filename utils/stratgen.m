function [data index] = stratgen(w, c, theta, sigma, phi, nsample)
% This function generates stratified samples for given strata parameters.
% The algorithm consists of following steps:
% 1) Generate strat index from a multinomial distribution
% 2) Generate a sample rank from a  gaussian distribution N(c(index), sigma(index))
% 3) Generate dim - 1 linear independent coordinates of a sample
% 4) Generate the last coordinate to satisfy an equation of hyper plane:
% x1*w1 + x2*w2 + ... xm*wm = r
% 5) Repeat from 1) untill desired number of samples is generated
%
% Inputs:
% w - criteria weights
% c - centers of strata
% theta - probabilities of each stratum
% sigma - stratum "thickness", i. e. deviation on center
% phi - stratum spread
% nsample - number of samples to be generated
%
% Outputs:
% data - samples coordinates
% index - index of strata
% =====================================================================

% Checks conditions on weights and strata probs
assert(abs(sum(w) - 1) < 1e-6, 'Weights must sum up to one!');
assert(abs(sum(theta) - 1) < 1e-6, 'Starta probabilities must sum up to one!');
assert(size(theta,2) == size(c,2), 'Number of strata probabilities must be equal to number of strata!');

% Some initializations
dim = size(w,2);
index = zeros(nsample,1);
data = zeros(nsample, dim);

if length(sigma) == 1
    sigma = ones(1,length(c)) *sigma;
end

for i = 1:nsample
    % 1. Generate strat index
    n = multinom(theta);
    index(i) = n;
    % 2. Generate sample rank from the normal distribution
    r = c(n) + sigma(n)*randn(1,1); 
    % 3. Generate n-1 linearly  independent  coordinates of the sample
    % data(i, 1: (dim-1)) =  (r./ w(1:(dim-1))) .* rand(1, (dim-1));
    % data(i, 1: (dim-1)) = (c(n) ./ w(1:(dim-1))) .* rand(1, (dim-1)); % def
    if phi == 0
         a = 0;
         b = c(n) ./  w(1:dim-1);
         data(i, 1: (dim-1)) = a + (b-a) .* rand(1,dim-1);
         % data(i, 1:(dim-1)) = (c(n) ./ w(1:(dim-1))) .* randn(1, (dim-1)); % def
    else
        % data(i, 1:(dim-1)) = c(n)*w(1:(dim-1)) + phi * randn(1, dim-1);
        
        % Uncomment  here
        a = 0.5 * c(n) * (1 - phi);
        b = 0.5 * c(n)  *(1 + phi) ./  w(1:dim-1) ;
        data(i, 1: (dim-1)) = a + (b-a) .* rand(1,dim-1);
    end
    % 4. Generate the last dependent coordinate
    data(i,dim) = (r - data(i, 1:(dim-1))*w(1:(dim-1))')/w(dim); % def
    assert(abs(w*data(i,:)'- r) < 1e-12, 'Projection must be equal to the rank');
end

% Check if there are empty strata
if length(unique(index)) ~= size(c,2)
    warning('Only %d strata created, while %d specified!', length(unique(index)) , size(c,2)); %#ok<WNTAG>
end
% data = datanorm(data);
end

function ret = multinom(theta)
% Samples a number [1...n] with probs [theta1 ... thetan]
x = rand(1,1);
prob = [0 cumsum(theta)];
for i =2:size(prob,2)
    if (x >= prob(i-1)) && (x < prob(i))
        ret = i -1;
        break;
    end
end
end