function out = pareto(x,y,alpha)

n = length(x);
out = 0;
for i = 1:n
    if x(i) <= (1+alpha)*y(i) || x(i) >= (1-alpha)*y(i)
        out = 0;
    elseif (out == 0) && (x(i) > (1 + alpha)*y(i))
        out = 1;
    elseif (out == 0) && (x(i) < (1 - alpha)*y(i))
        out = -1;
    elseif ((out == 1) && (x(i) < (1 - alpha)*y(i))) || ((out == -1) && (x(i) > (1 + alpha)*y(i)))
        out = 0;
        break
    end
end