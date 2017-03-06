function [w,S,c] = partswarm(Y,niter,populsize,phip,phig,omega)
%--------------------------------------------------------------------------
% PSO �����������
% ������� ���� w ��� �������� ������� ������� � � ��������� S
%--------------------------------------------------------------------------
% �������������� ���������
m = length(Y(1,:));
v = rand(populsize,m);
popul = rand(populsize,m); % ��������� �������� �����
popul = sort(popul,2);
prew = popul(:,1);
for i=2:m-1 
    next = popul(:,i);
    popul(:,i) = next - prew; 
    prew = next;
end
popul(:,m) = ones(populsize,1) - prew;

gmin = 1e6; % ���������� ������� ������� �������
w = ones(1,m)/m; % ������ ������������ ���������� �������
tp = 1e6*ones(populsize,1); % ������ ��������� ��� ���������
wp = zeros(populsize,m)/m; % ������ ������ ��� ������� ���������
% ������������ �����������
t = zeros(populsize,1); % �������� ������� ������� �� ���������
for k = 1:niter
    for j = 1:populsize
        % ��������� �������� ������� ������� ��� ���� ������ ���������
       [S c] = findgroups(Y,popul(j,:),[]);
       t(j) = targf(Y,S,c,popul(j,:));
       if t(j) < tp(j)
           tp(j) = t(j);
           wp(j,:) = popul(j,:); 
       end
    end

    [lmin pos] = min(t);
    if lmin < gmin
        % ���������� ����� ���������� ������
        gmin = lmin;
        w = popul(pos,:);
    end
    
    %disp(gmin);
    
    % ������������ ���������
    rp = -1 + 2*rand(1,1); % �������� ���������
    rg = -1 + 2*rand(1,1); %
    % �������� ��������
    v = omega*v + phip*rp*(wp - popul) + phig*rg*(repmat(w,populsize,1) - popul);
    % ��������� ����� ����������;
    popul = popul + v; 
    % ������������ �����������������
    popul = max(zeros(populsize,m),popul);
    % �������� ����� ����� � �������
    div = repmat(sum(popul,2),1,m);
    popul = popul./div;
    
end

[S c] = findgroups(Y,w,[]);

end
%--------------------------------------------------------------------------
function t = targf(Y,S,c,w)
%--------------------------------------------------------------------------
% ���������� ������� ������
%--------------------------------------------------------------------------
e = Y*w' - S*c';
t = sum(e.*e);

end