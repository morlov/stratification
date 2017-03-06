function [w,S,c] = partswarm(Y,niter,populsize,phip,phig,omega)
%--------------------------------------------------------------------------
% PSO минимизации
% находим веса w при заданным векторе центров с и разбиении S
%--------------------------------------------------------------------------
% инициализируем попул€цию
m = length(Y(1,:));
v = rand(populsize,m);
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
tp = 1e6*ones(populsize,1); % лучший результат дл€ участника
wp = zeros(populsize,m)/m; % лучший вектор дл€ каждого участника
% эволюционна€ минимизаци€
t = zeros(populsize,1); % значени€ целевой функции на попул€ции
for k = 1:niter
    for j = 1:populsize
        % вычисл€ем значение целевой функции дл€ всех особей попул€ции
       [S c] = findgroups(Y,popul(j,:),[]);
       t(j) = targf(Y,S,c,popul(j,:));
       if t(j) < tp(j)
           tp(j) = t(j);
           wp(j,:) = popul(j,:); 
       end
    end

    [lmin pos] = min(t);
    if lmin < gmin
        % записываем новый глобальный мнимум
        gmin = lmin;
        w = popul(pos,:);
    end
    
    %disp(gmin);
    
    % видоизмен€ем попул€цию
    rp = -1 + 2*rand(1,1); % параметр алгоритма
    rg = -1 + 2*rand(1,1); %
    % вычисл€м скорость
    v = omega*v + phip*rp*(wp - popul) + phig*rg*(repmat(w,populsize,1) - popul);
    % вычисл€ем новые координаты;
    popul = popul + v; 
    % обеспечиваем неотрицательность
    popul = max(zeros(populsize,m),popul);
    % приводим сумму весов к единице
    div = repmat(sum(popul,2),1,m);
    popul = popul./div;
    
end

[S c] = findgroups(Y,w,[]);

end
%--------------------------------------------------------------------------
function t = targf(Y,S,c,w)
%--------------------------------------------------------------------------
% вычисление целевой функци
%--------------------------------------------------------------------------
e = Y*w' - S*c';
t = sum(e.*e);

end