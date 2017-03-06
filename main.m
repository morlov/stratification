function main
clc;
clear all;
%Y = [ 1.0 0.9;
%       0.9 1.0;
%       0.5 0.4;
%       0.4 0.5;
%       0.1 0.0;
%       0.0 0.1];

% w = [0.5 0.5];  % задаем значения весов
% n = length(w); % размерность выборки
% c  = [0.8 0.5 0.3]; % центры классов
% sigma = 0.001; % дисперсия шума
% N = 30; % число элементов в страте
% [Y ~] = generateStrata(w,c,sigma,N,0);
% t = cputime;
%% real data

load 'C:\Users\m.orlov\Dropbox\hse\phd\stratification_code\datasets\alco.m' alco
Y = alco;
algType = 5;

%% evolutionary optimization
if algType == 0
populsize = 200;
niter = 100;
param = 0.01; % параметр алгоритма
[w, S, c] = evolmin(Y,niter,populsize,param);
r = Y*w';
e = Y*w' - S*c';
targ = sum(e.*e);
% disp(targ);
plot(w);
figure;
plot(Y*w');
% pause();

%%  particl swarm optimisation
% phip = 4; 
% phig = 1;
% omega = 0.8;
% t = cputime;
% [w, S, c] = partswarm(Y,niter,populsize,phip,phig,omega);
% del = cputime - t;
% disp(del);
% e = Y*w' - S*c';
% targ = sum(e.*e);
% disp(targ);
% % disp(S);
% disp(w);


%% linear prigramming based
elseif algType == 1
[r,S,c] = linprogStrat(Y);
% disp(S);
% disp(c);

%% authorities ranking based
elseif algType == 2
% t = cputime;
[w, S, c] = authorityStrat(Y);
r = Y*w';
% disp(w);
% disp(S);
% disp(c);
% disp(Y*w');

%% pareto based strat
elseif algType == 3
S = paretoStrat(Y);
% disp(S);

%% kmeans based strat
elseif algType == 4
 S = kmeansStrat(Y,50);
% disp(S);
% disp(S);

%% borda strat
elseif algType == 5
[~,index_est] = bordaStrat(Y,3,25);
% disp(S);
% disp(S);

%% simple k-means
elseif algType == 6
    
    
end

 accuracy = double(sum(index_est == index_true))/length(index_true);
 disp(accuracy)
%% визуализауия
% disp(cputime - t);
% axis([0.2 1.1 0.2 1.1]);
% I1 = find(S(:,1));
% plot(Y(I1,1),Y(I1,2),'or','MarkerSize',10);
% hold on;
% I2 = find(S(:,2));
% axis([0.2 1.1 0.2 1.1]);
% plot(Y(I2,1),Y(I2,2),'*g','MarkerSize',10);
% hold on;
% axis([0.2 1.1 0.2 1.1]);
% I3 = find(S(:,3));
% plot(Y(I3,1),Y(I3,2),'+b','MarkerSize',10);
% hold off;

% [~, J] = sort(r,'descend');
% for i = 1:23
%     I(i) = find(J==i);
% end
% I = I';
end
