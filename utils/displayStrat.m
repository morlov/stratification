clc;
clear all;
% ========================= рисуем страты =================================
w = [0.3 0.3 0.4];  % задаем значения весов
n = length(w); % размерность выборки
c  = [0.8 0.5 0.3]; % центры классов
N = 1000; % число элементов в страте
dataType = 1;
%=========================== sigma = 0 ====================================
sigma = [0.0 0.07 0.12];
% ttl = {'Cloud strata,sigma=0.05','Cloud strata,sigma=0.1'};

for i = 1:3
    % subplot(1,3,i);
    [Y ~] = generateStrata(w,c,sigma(i),N,dataType);
    Y = dataNormalize(Y);
    hold on;
    axis([-0.1 1.1 -0.1 1.1 -0.1 1.1]);
    plot3(Y(1:N,1),Y(1:N,2),Y(1:N,3),'r*','MarkerSize',7);
    plot3(Y(N+1:2*N,1),Y(N+1:2*N,2), Y(N+1:2*N,3),'go','MarkerSize',7);
    plot3(Y(2*N+1:3*N,1),Y(2*N+1:3*N,2), Y(2*N+1:3*N,3),'bx','MarkerSize',7);
    % title(ttl{i});
    hold off;
end
