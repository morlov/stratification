clear all;
clc;
% �������� ��� ��������� � ������
algType = 0; 
dataType = 0;

% =========================== �������� ���� ===============================
N_loop  = 50; % ����� �������� ��� ������ ��������
accuracy = zeros(N_loop,1); % �������� ������������
% ======================== ������ �������� ����� ==========================
dim = 8;
w = rand(N_loop,dim); % �������� ����������� ����
w = sort(w,2);
prew = w(:,1);
for i=2:dim-1 
    next = w(:,i);
    w(:,i) = next - prew; 
    prew = next;
end
w(:,dim) = ones(N_loop,1) - prew;
for loop = 1:N_loop
   % ================= ���������� ������ ��� ������������ =================
    n = length(w); % ����������� �������
    c  = [0.8 0.5 0.3]; % ������ �������
    sigma = 0.0; % ��������� ����
    N = 30; % ����� ��������� � ������
    [Y trueClass] = generateStrata(w(loop,:),c,sigma,N,dataType);
   % ==================== ����������� LinStrat =============================
    populsize = 50; % ������ ���������
    niter = 50; % ����� ����
    param = 0.01; % �������� ��������
    [predictedWeights, S, predictedCenter] = evolmin(Y,niter,populsize,param); % �������������
    % disp(predictedCenter);
    predictedRank = Y*predictedWeights';
    trueRank = Y*w(loop,:)';
    %accuracy(loop) = corr(predictedRank,trueRank,'type','Kendall');
    % ===== ��������� �������� ������������ =========
    % accuracy(loop) = max(abs(c - predictedCenter));
    
    % ==================== ������������ ������������ ======================
    accuracy(loop) = corr(trueRank,predictedRank,'type','Spearman');%rankDistance(trueRank,predictedRank);
    % ==================== ����������� ParetStrat =========================
%     S = paretoStrat(Y);
%     predictedClass =  S(:,1) + 2*S(:,2) + 3*S(:,3); % ������������� ����� �������
%     % ���������� ������� ����������
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
