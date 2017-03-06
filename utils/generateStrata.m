function [Y indexes] = generateStrata(w,c,sigma,N,dataType)
% -------------------------------------------------------------------------
% generateStrata ���������� ��������� ���� �����
% ������� ������:
% c ������ �������
% sigma - ��������� ����
% N - ����� ��������� � ������
% k - ������ ������ � �������
% dataType - ��� ������ 0 - �������� ������, 1 - �����������, 2 - ��������
% �������� ������:
% Y - ����� 
% indexes - ������� �������������� � ������� {1,2,3}
% -------------------------------------------------------------------------
n = length(w); % ����������� �������
Y = zeros(3*N,n); % ������������� �������
indexes(1:N) = 1;
indexes(N+1:2*N) = 2;
indexes(2*N + 1:3*N) = 3;

if dataType == 0 
   % ������������� ������
   % ������ n-1 ���������� ���������� ��������
   Y(1:N,1:n-1) =  c(1) + rand(N,n-1); % ����� ������� ������
   Y(N+1:2*N,1:n-1) = c(2)  + rand(N,n-1); % ����� ������� ������
   Y(2*N+1:3*N,1:n-1) = c(3) + rand(N,n-1); % ����� �������� �����
        
   % ��������� ���������� ���������� �� ��������� ���������
   % w1*x1 + w2*x2 + ... + wn*xn = c
   for i = 1:N
        Y(i,n) = (c(1) - w(1:n-1)*Y(i,1:n-1)')/w(n);
        Y(N+i,n) = (c(2) - w(1:n-1)*Y(N+i,1:n-1)')/w(n);
        Y(2*N+i,n) = (c(3) - w(1:n-1)*Y(2*N+i,1:n-1)')/w(n);
   end
   % ��������� ��������� ������
   Y = Y + sigma*randn(3*N,n);
   
elseif dataType == 1 % ������ ���� �����
   % ������ n-1 ���������� ���������� ��������
   Y(1:N,1:n-1) =  c(1) + 2*rand(N,n-1); % ����� ������� ������
   Y(N+1:2*N,1:n-1) = c(2) + 2*rand(N,n-1); % ����� ������� ������
   Y(2*N+1:3*N,1:n-1) =  c(3) + 2*rand(N,n-1); % ����� �������� �����
        
   % ��������� ���������� ���������� �� ��������� ���������
   % w1*x1^2 + w2*x2^2 + ... + wn*xn^2 = c
   w = ones(1,n);
   for i = 1:N
       Y(i,n) = sqrt(abs(c(1)^2 - w(1:n-1)*Y(i,1:n-1)'.^2))/w(n);
       Y(N+i,n) = sqrt(abs(c(2)^2 - w(1:n-1)*Y(N+i,1:n-1)'.^2))/w(n);
       Y(2*N+i,n) = sqrt(abs(c(3)^2 - w(1:n-1)*Y(2*N+i,1:n-1)'.^2))/w(n);
   end
   % ��������� ��������� ������
   Y = Y + sigma*randn(3*N,n);
   
elseif dataType == 2 % ��������
    
   Y(1:N,:) =  abs(c(1)*ones(N,n) + sigma*randn(N,n)); % ����� ������� ������
   Y(N+1:2*N,:) = abs(c(2)*ones(N,n) + sigma*randn(N,n)); % ����� ������� ������
   Y(2*N+1:3*N,:) =  abs(c(3)*ones(N,n) + sigma*randn(N,n)); % ����� �������� �����
    
end