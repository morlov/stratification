clear all;
clc;
% выбираем тип алгоритма и данных
algType = 0; 
dataType = 0;

% =========================== основной цикл ===============================
N_loop  = 50; % число итераций дл€ оценки точности
accuracy = zeros(N_loop,1); % точность пердсказани€
% ======================== задаем значени€ весов ==========================
dim = 8;
w = rand(N_loop,dim); % случайно гененриурем веса
w = sort(w,2);
prew = w(:,1);
for i=2:dim-1 
    next = w(:,i);
    w(:,i) = next - prew; 
    prew = next;
end
w(:,dim) = ones(N_loop,1) - prew;
for loop = 1:N_loop
   % ================= генерируем данные дл€ эксперимента =================
    n = length(w); % размерность выборки
    c  = [0.8 0.5 0.3]; % центры классов
    sigma = 0.0; % дисперси€ шума
    N = 30; % число элементов в страте
    [Y trueClass] = generateStrata(w(loop,:),c,sigma,N,dataType);
   % ==================== верификаци€ LinStrat =============================
    populsize = 50; % размер попул€ции
    niter = 50; % число эпох
    param = 0.01; % параметр обучени€
    [predictedWeights, S, predictedCenter] = evolmin(Y,niter,populsize,param); % кластеризаци€
    % disp(predictedCenter);
    predictedRank = Y*predictedWeights';
    trueRank = Y*w(loop,:)';
    %accuracy(loop) = corr(predictedRank,trueRank,'type','Kendall');
    % ===== вычисл€ем точность предсказани€ =========
    % accuracy(loop) = max(abs(c - predictedCenter));
    
    % ==================== ѕравильность ранжировани€ ======================
    accuracy(loop) = corr(trueRank,predictedRank,'type','Spearman');%rankDistance(trueRank,predictedRank);
    % ==================== верификаци€ ParetStrat =========================
%     S = paretoStrat(Y);
%     predictedClass =  S(:,1) + 2*S(:,2) + 3*S(:,3); % предсказанные метки классов
%     % построение матрицы соответсий
%     contmat = zeros(3,3);
%     for k = 1:3*N
%         i = trueClass(k);
%         j = predictedClass(k);
%         contmat(i,j) = contmat(i,j) + 1;
%     end
%     accuracy(loop) = sum(diag(contmat))/sum(sum(contmat));
  clc; 
disp(loop);
   
    
end
disp(mean(accuracy));
disp(std(accuracy));
