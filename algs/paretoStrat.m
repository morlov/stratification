function [S, index] = paretoStrat(x, nstrat, ~)

n = size(x,1);
idc = 1:n;
temp_id = zeros(n,1);
k = 0;

% получаем классы парето недоминируемых обектов
while ~isempty(idc)
    nondom = [];
    for i = idc
        % смотрим профиль объекта
        prof = pareto_prof(x(i,:),x(idc,:));
        if ~any(prof == -1)
            nondom = [nondom, i];
        end
    end
    % все недоминируемые объекты найдены
    idc = setdiff(idc, nondom); % удаляем недоминируемые объекты и продолжаем
    temp_id(nondom) = k+1; % записываем индексы страт
    k = k + 1;
end

if length(unique(temp_id)) > 3
    d = zeros(k-1,1); % парные расстояния
    for i = 1:k-1
        % вычисляем парные расстояния как минимальные расстояния среди всех
        % объектов
        % d(i) = min(min(dist(v(tempS == i,:),x(tempS == i+1,:)')));
        % d(i) = max(max(dist(v(tempS == i,:),x(tempS == i+1,:)')));
        d(i) = mean(mean(dist(x(temp_id == i,:), x(temp_id == i+1,:)')));
    end
    
    [~, merg] = sort(d, 'descend');
    merg = sort(merg(1:nstrat-1));
    temp_id(temp_id <= merg(1)) =  1;
    for i = 2:nstrat-1
        temp_id((temp_id > merg(i-1)) & (temp_id <= merg(i))) =  i;
    end
    temp_id(temp_id > merg(nstrat-1)) = nstrat;
end
index = temp_id;
S = zeros(n,nstrat);
for i = 1:n
S(i, index(i)) = 1;
end
index = nstrat - index + 1;
end

function profile = pareto_prof(a, x)
% функция возвращает профиль для элемента a из массива X
% -1 те элементы, которые доминируют a
% 1 те элементы, которых доминирует a
% 0 элементы несравнимые или безразличные с a
n = size(x,1);
profile = zeros(n,1);
for i = 1:n
    profile(i) = R(a, x(i,:));
end
end

% Vector >= relation
function res = R(x,y)
z = x >= y;
res = any(z) * all(z) - all(~z);
end

