function [w,index,c] = authorityStrat(Y, nstrat, nrep)

data = Y;
X = Y'; % вычисляем смежную матрицу
% нормируем матрицы X и Y так чтобы сумма элементов в строках
% были равны единице
Y = Y./repmat(sum(Y,2),1,size(Y,2));
Y(isnan(Y)) = 0;
X = X./repmat(sum(X,2),1,size(Y,1));
B = X*Y;
K = length(B);
B = B' - diag(ones(K,1));
B(K,:) = ones(1,K);
% вычисляем веса критериев
w = linsolve(B,[zeros(K-1,1);1]);
w = w';
r = data*w';
r = r/max(r);
[index, c] = best_stratify(r, nstrat, nrep);
if ~exist('index','var')
    disp('Something happend ...');
end
end
