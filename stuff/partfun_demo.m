function partfun_demo

x = linspace(-1,3,100)';
y = f(x, 10);

plot(x, y);
end

function y = f(x, n)
m = size(x, 1);
r = 0:(n-1);
y = sum(sigmoid(repmat(x, 1, n) - repmat(r, m, 1)), 2);
end

function z = sigmoid(x)
    z = 1./(1 + exp(-x*100));
end
