function [c index] = bordaStrat(data, nstrat, nrep)
nsample = size(data,1);
r = zeros(nsample,1);
for i = 1:nsample
    r(i) = bordrank(data(i,:),data);
end
r = r/max(r);
[index, c] = best_stratify(r, nstrat, nrep);
end