function w = evolmin(data,nstrat,niter,populsize,param)
%--------------------------------------------------------------------------
% ������������ �����������
% ������� ���� w ��� �������� ������� ������� � � ��������� S
%--------------------------------------------------------------------------

% �������������� ���������
m = size(data,2);
nsample = size(data,1);
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
S = zeros(nsample, nstrat);
% ������������ �����������
t = zeros(populsize,1); % �������� ������� ������� �� ���������
for k = 1:niter
    
    for j = 1:populsize
        % ��������� �������� ������� ������� ��� ���� ������ ���������
       [index c] = stratify(data*popul(j,:)',nstrat);
       for i = 1:nstrat
           S(:,i) = (index == i);
       end
        t(j) = targf(data,S,c,popul(j,:));
    end

    
    [lmin pos] = min(t);
    if lmin < gmin
        % ���������� ����� ���������� ������
        gmin = lmin;
        w = popul(pos,:);
    else
       % �������� ������� ������
       [~,lmi] = max(t);
       t(lmi) = gmin;
       popul(lmi,:) = w;
    end
    
    % ������������ ���������
  
    % ��������� ��������� �����
    popul = popul + param*randn(populsize,m); 
    % ������������ �����������������
    popul = max(zeros(populsize,m),popul);
    % �������� ����� ����� � �������
    div = repmat(sum(popul,2),1,m);
    popul = popul./div;
    
end

end
%--------------------------------------------------------------------------
function t = targf(Y,S,c,w)
%--------------------------------------------------------------------------
% ���������� ������� ������
%--------------------------------------------------------------------------
e = Y*w' - S*c';
t = sum(e.*e);
end
