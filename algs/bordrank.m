function out = bordrank(x,data)
out = 0;
m = size(data,2);
for k = 1:m
    out = out + length(find(data(:,k) <= x(k)));
end
out = out/m;
end