function w = evolmin(data,nstrat,niter,populsize,param)
%--------------------------------------------------------------------------
% эволюционна€ минимицации
% находим веса w при заданным векторе центров с и разбиении S
%--------------------------------------------------------------------------

% инициализируем попул€цию
m = size(data,2);
nsample = size(data,1);
popul = rand(populsize,m); % попул€ци€ векторов весов
popul = sort(popul,2);
prew = popul(:,1);

for i=2:m-1 
    next = popul(:,i);
    popul(:,i) = next - prew; 
    prew = next;
end
popul(:,m) = ones(populsize,1) - prew;

gmin = 1e6; % глобальный минимум целевой функции
w = ones(1,m)/m; % вектор доставл€ющий глобальный минимум
S = zeros(nsample, nstrat);
% эволюционна€ минимизаци€
t = zeros(populsize,1); % значени€ целевой функции на попул€ции
for k = 1:niter
    
    for j = 1:populsize
        % вычисл€ем значение целевой функции дл€ всех особей попул€ции
       [index c] = stratify(data*popul(j,:)',nstrat);
       for i = 1:nstrat
           S(:,i) = (index == i);
       end
        t(j) = targf(data,S,c,popul(j,:));
    end

    
    [lmin pos] = min(t);
    if lmin < gmin
        % записываем новый глобальный мнимум
        gmin = lmin;
        w = popul(pos,:);
    else
       % замен€ем худшего лучшим
       [~,lmi] = max(t);
       t(lmi) = gmin;
       popul(lmi,:) = w;
    end
    
    % видоизмен€ем попул€цию
  
    % добавл€ем случайное число
    popul = popul + param*randn(populsize,m); 
    % обеспечиваем неотрицательность
    popul = max(zeros(populsize,m),popul);
    % приводим сумму весов к единице
    div = repmat(sum(popul,2),1,m);
    popul = popul./div;
    
end

end
%--------------------------------------------------------------------------
function t = targf(Y,S,c,w)
%--------------------------------------------------------------------------
% вычисление целевой функци
%--------------------------------------------------------------------------
e = Y*w' - S*c';
t = sum(e.*e);
end
