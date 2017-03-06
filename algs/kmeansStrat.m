function [medoid_best, index] = kmeansStrat(x, nstrat, nrep)
% Modified to ordered classes k-means clustering

maxiter = 25;
n = size(x,1);
index = zeros(n,1); 
index_prew = zeros(n,1); 
d = prof_pdist2(x);

cost_best = 1e6;

for repl = 1:nrep
    
    % Init medoids
    perm = randperm(n);
    medoid = perm(1:nstrat);
    
    % Main loop
    for iter = 1:maxiter
        
        % Min distance cluster ssignment
        for i = 1:n
            % Distances from elements to medoids
            md = zeros(nstrat, 1);
            for j = 1:nstrat
                md(j) = d(i, medoid(j));
            end
            [~, index(i)] = min(md);
        end
        
        % Medoid updating
        for k = 1:nstrat
            idx = find(index == k); % Elements of k-th stratum
            [~, m] = min(sum(d(idx, idx), 2));
            medoid(k) = idx(m);
        end
        
        % Termination checking
        if all(index_prew == index)
            break;
        end
        
        index_prew = index;
    end
    
    % Compute cost of solution
    cost = 0;
    for k = 1:nstrat
        idx = index == k; % Elements of k-th stratum
        cost = cost +  sum(d(idx, medoid(k)));
    end
    
    if (cost < cost_best)
        cost_best = cost;
        index_best = index;
        medoid_best = medoid;
    end
    
end

% Obtain final ranking of clusters by borda ranking of medoids
r = zeros(nstrat, 1);
for i = 1:nstrat
    m = medoid_best(i);
    r(i) = bordrank(x(m, :), x);
end

% Rank medoids according to borda rank and rename indicies
[~, temp_idx] = sort(r, 'ascend');
for i = 1:n
    index(i) = find(temp_idx == index_best(i));
end
end

function d = prof_dist(p1,p2)
% Distance between two profiles
n = length(p1);
d1 = sum((p1 == -1) .* (p2 == -1));
d2 = sum((p1 ==  0) .* (p2 ==  0));
d3 = sum((p1 ==  1) .* (p2 ==  1));
d4 = sum((p1 ==  2) .* (p2 ==  2));
d = 1 -  (d1 + d2 + d3 + d4) / n;
end

function d = prof_pdist2(x)
% Pair-wise profile distances between elements in x
n = size(x, 1);
d = zeros(n,n); 
prof = zeros(n,n);

for i = 1:n
    prof(i,:) = pareto_prof(x(i,:), x);
end

for i = 2:n
    for j = 1:n-1
        d(i,j) = prof_dist(prof(i,:), prof(j, :));
        d(j,i) = d(i,j);
    end
end
end

function profile = pareto_prof(a, x)
% Pareto profile of element a in set x
n = size(x,1);
profile = zeros(n,1);
for i = 1:n
    profile(i) = R(a, x(i,:));
end
end

% Vector >= relation
function ret = R(x,y)
z = x >= y;
if all(x == y) 
    ret  = 0; % Equal elements
elseif any(z) && any(~z)
    ret = 2; % Incomparabale
else
    ret = all(z) - all(~z); % Rest
end
end