function [index c] = best_stratify(r, nstrat, nrep)
cost_best = 1e6;
for i = 1:nrep
    [index_temp c_temp cost] = stratify(r, nstrat);
    if cost < cost_best
        cost_best = cost;
        index = index_temp;
        c = c_temp;
    end
end
end