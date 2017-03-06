function [P1, P2, P3, P4] = getProfile(a,X)

N = size(X,1);
P1 = [];
P2 = [];
P3 = [];
P4 = [];
for i = 1:N
    
    if (R(a,X(i,:)) == 2) 
        P1 = [P1 i]; % incompatible
    elseif (R(a,X(i,:)) == 0) 
        P3 = [P3 i]; % equal
    elseif (R(a,X(i,:)) == 1) 
        P4 = [P4 i]; % dominates
    elseif (R(a,X(i,:)) == -1) 
        P2 = [P2 i]; % is dominated
    end

end
% функция реализует отношение парето
function out = R(x,y)

n = length(x);
out = 0;

for i = 1:n
    if (out == 0) && (x(i) <= y(i)) && (x(i) >= y(i))
        out = 0;
    elseif (out == 0) && (x(i) > y(i))
        out = 1;
    elseif (out == 0) && (x(i) < y(i))
        out = -1;
    elseif ((out == 1) && (x(i) < y(i))) || ((out == -1) && (x(i) > y(i)))
        out = 2;
        break
    end
end
