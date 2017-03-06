function ret =  hamming_distance(r1, r2)
    % Number of pairwise mismatches of two adjacency matrix for rankings r1, r2
    sz1 = size(r1);
    n = sz1(1); m1 = sz1(2);
    sz2 = size(r2);
    m2 = sz2(2);
    ret  = zeros(m1,m2);
    for i = 1:m1
        for j = 1:m2
            d = abs(rank2mat(r1(:,i)) - rank2mat(r2(:,j)));
            ret(i,j) = sum(d(:))/(n*(n-1));
        end
    end
end

function m = rank2mat(r)
% Creates adjacency matrix for a rankig r
    n = length(r);
    m  = zeros(n,n);
    for i = 1:n
        for j = 1:n
            m(i, j) = (r(i) > r(j));
        end
    end
end