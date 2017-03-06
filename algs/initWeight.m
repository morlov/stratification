function w = initWeight(m)
% Initialize a random uniform vector from [0 1]^m
w = rand(1,m);
w = sort(w);
prew = w(1);

for i=2:m-1 
    next = w(i);
    w(i) = next - prew; 
    prew = next;
end
w(m) = 1 - prew;