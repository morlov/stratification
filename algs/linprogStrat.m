function [w, index,c] = linprogStrat(data, nstrat, nrep)

n = size(data,1);
m = size(data,2);
r = zeros(n,1);
options = optimset('LargeScale', 'on', 'Simplex', 'on', 'Display','off', 'MaxIter',25,'TolFun',1e-6);
for i = 1:n
    w = linprog(-data(i,:)',data,ones(n,1),[],[],zeros(m,1),[],[],options);
    r(i) = data(i,:)*w;
end
r = r/max(r);
[index, c] = best_stratify(r, nstrat, nrep);
end

