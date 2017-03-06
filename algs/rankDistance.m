function d = rankDistance(r1,r2)
n = length(r1);
R1 = zeros(n);
R2 = zeros(n);
for i = 1:n
    for j = i:n
        R1(i,j) = (r1(i)<r1(j));
        R1(j,i) = (r1(i)>r1(j));
        R2(i,j) = (r2(i)<r2(j));
        R2(j,i) = (r2(i)>r2(j));
    end
end

d = 1/(n*(n-1))*sum(sum(abs(R1-R2)));