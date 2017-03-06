clear all;
clc;
% выбираем тип алгоритма algType:
% algType = 0 linStrat
% algType = 1 authoritiesStrat
% algType = 2 linprogStrat
% algType = 3 paretoStrat
% algType = 4 bordStrat
% algType = 5 kmeansStrat
algType = 3; 

% выбираем тип данных dataType:
% dataType = 0 линейные страты
% dataType = 1 сферические страты
% dataType = 2 точечные страты
dataType = 0;

% =========================== основной цикл ===============================
N_loop  = 1; % число итераций дл€ оценки точности
accuracy = zeros(N_loop,1); % точность кластеризации
for loop = 1:N_loop
   % ================= генерируем данные дл€ эксперимента =================
   w = initWeight(2); 
   % w = [0.5 0.5];  % задаем значени€ весов
    n = length(w); % размерность выборки
    c  = [0.8 0.5 0.3]; % центры классов
    % c = sort(rand(3,1), 'descend')';
    sigma = 0.001; % дисперси€ шума
    N = 100; % число элементов в страте
    [Y trueClass] = generateStrata(w,c,sigma,N,dataType);
    % Y = dataNormalize(Y);
    if dataType == 3
        load C:\Orlov\¬ышка\ƒиплом\ƒанные\bankbranches.mat Y;
        Y = Y./repmat(max(Y),length(Y),1);
        n = size(Y,1);
    end
    
    % ==================== тестируем алгоритмы ============================
    if algType == 0
        % предложенный алгоритм
        populsize = 50; % размер попул€ции
        niter = 20; % число эпох
        param = 0.01; % параметр обучени€
        % [predictedWeights, S, c] = evolmin(Y,niter,populsize,param); % кластеризаци€
        [w_predicted,~, c_predicted]  = linStratEvol(Y, 3, 25);
        disp(c)
        disp(c_predicted(3:-1:1))
        predictedRank = Y*predictedWeights';
    elseif algType == 1
        % алгоритм основанный на authorities ranking
        [predictedWeights, S, c] = authorityStrat(Y);
        predictedRank = Y*predictedWeights'; % предсказанный ранг объектов
        % disp(predictedWeights);
    elseif algType == 2
        % алгоритм на основе линейного программировани€
        [r,S,c] = linprogStrat(Y);
    elseif algType == 3
        % алгоритм основанный на границе парето
        S = paretoStrat(Y, 3);
    elseif algType == 4
        % алгоритм основанный на правиле борда
        S = bordStrat(Y);
    elseif algType == 5
        % алгоритм основанный на к средних
        S = kmeansStrat(Y,100);
    end
    % находим метки классов
    I1 = find(S(:,1)); % находим точки из второго класса
    I2 = find(S(:,2)); % второй класс
    I3 = find(S(:,3)); % третий класс
    % ===== строим матрицу соответсвий дл€ оцениваемого алгоритма =========
    predictedClass =  S(:,1) + 2*S(:,2) + 3*S(:,3); % предсказанные метки классов
    % построение матрицы соответсий
    contmat = zeros(3,3);
    for k = 1:3*N
        i = trueClass(k);
        j = predictedClass(k);
        contmat(i,j) = contmat(i,j) + 1;
    end
    accuracy(loop) = sum(diag(contmat))/sum(sum(contmat));
    %disp(contmat);
    clc;
    disp(loop);
    % ======== визуализаци€ данных только в двумерном случае ==============
    if (n == 2)&&(N_loop == 1)
        % axis([0 1 0 1]);
        hold on;
        % истинное распределение по классам
        plot(Y(1:N,1),Y(1:N,2),'r*');
        plot(Y(N+1:2*N,1),Y(N+1:2*N,2),'g.');
        plot(Y(2*N+1:3*N,1),Y(2*N+1:3*N,2),'bx');
        %subplot(3,1,3);
        %plot(Y(1:N,1),Y(1:N,2),'r*',Y(N+1:2*N,1),Y(N+1:2*N,2),'g.',Y(2*N+1:3*N,1),Y(2*N+1:3*N,2),'bx');
        % предсказанное распределение по классам
        plot(Y(I1,1),Y(I1,2),'or');
        plot(Y(I2,1),Y(I2,2),'og');
        plot(Y(I3,1),Y(I3,2),'ob');
        hold off;
    end   
end

disp(mean(accuracy));
disp(std(accuracy));