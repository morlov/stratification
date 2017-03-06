clear all;
clc;
% �������� ��� ��������� algType:
% algType = 0 linStrat
% algType = 1 authoritiesStrat
% algType = 2 linprogStrat
% algType = 3 paretoStrat
% algType = 4 bordStrat
% algType = 5 kmeansStrat
algType = 3; 

% �������� ��� ������ dataType:
% dataType = 0 �������� ������
% dataType = 1 ����������� ������
% dataType = 2 �������� ������
dataType = 0;

% =========================== �������� ���� ===============================
N_loop  = 1; % ����� �������� ��� ������ ��������
accuracy = zeros(N_loop,1); % �������� �������������
for loop = 1:N_loop
   % ================= ���������� ������ ��� ������������ =================
   w = initWeight(2); 
   % w = [0.5 0.5];  % ������ �������� �����
    n = length(w); % ����������� �������
    c  = [0.8 0.5 0.3]; % ������ �������
    % c = sort(rand(3,1), 'descend')';
    sigma = 0.001; % ��������� ����
    N = 100; % ����� ��������� � ������
    [Y trueClass] = generateStrata(w,c,sigma,N,dataType);
    % Y = dataNormalize(Y);
    if dataType == 3
        load C:\Orlov\�����\������\������\bankbranches.mat Y;
        Y = Y./repmat(max(Y),length(Y),1);
        n = size(Y,1);
    end
    
    % ==================== ��������� ��������� ============================
    if algType == 0
        % ������������ ��������
        populsize = 50; % ������ ���������
        niter = 20; % ����� ����
        param = 0.01; % �������� ��������
        % [predictedWeights, S, c] = evolmin(Y,niter,populsize,param); % �������������
        [w_predicted,~, c_predicted]  = linStratEvol(Y, 3, 25);
        disp(c)
        disp(c_predicted(3:-1:1))
        predictedRank = Y*predictedWeights';
    elseif algType == 1
        % �������� ���������� �� authorities ranking
        [predictedWeights, S, c] = authorityStrat(Y);
        predictedRank = Y*predictedWeights'; % ������������� ���� ��������
        % disp(predictedWeights);
    elseif algType == 2
        % �������� �� ������ ��������� ����������������
        [r,S,c] = linprogStrat(Y);
    elseif algType == 3
        % �������� ���������� �� ������� ������
        S = paretoStrat(Y, 3);
    elseif algType == 4
        % �������� ���������� �� ������� �����
        S = bordStrat(Y);
    elseif algType == 5
        % �������� ���������� �� � �������
        S = kmeansStrat(Y,100);
    end
    % ������� ����� �������
    I1 = find(S(:,1)); % ������� ����� �� ������� ������
    I2 = find(S(:,2)); % ������ �����
    I3 = find(S(:,3)); % ������ �����
    % ===== ������ ������� ����������� ��� ������������ ��������� =========
    predictedClass =  S(:,1) + 2*S(:,2) + 3*S(:,3); % ������������� ����� �������
    % ���������� ������� ����������
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
    % ======== ������������ ������ ������ � ��������� ������ ==============
    if (n == 2)&&(N_loop == 1)
        % axis([0 1 0 1]);
        hold on;
        % �������� ������������� �� �������
        plot(Y(1:N,1),Y(1:N,2),'r*');
        plot(Y(N+1:2*N,1),Y(N+1:2*N,2),'g.');
        plot(Y(2*N+1:3*N,1),Y(2*N+1:3*N,2),'bx');
        %subplot(3,1,3);
        %plot(Y(1:N,1),Y(1:N,2),'r*',Y(N+1:2*N,1),Y(N+1:2*N,2),'g.',Y(2*N+1:3*N,1),Y(2*N+1:3*N,2),'bx');
        % ������������� ������������� �� �������
        plot(Y(I1,1),Y(I1,2),'or');
        plot(Y(I2,1),Y(I2,2),'og');
        plot(Y(I3,1),Y(I3,2),'ob');
        hold off;
    end   
end

disp(mean(accuracy));
disp(std(accuracy));