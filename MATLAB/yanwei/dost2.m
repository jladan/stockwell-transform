function D2coeff = dost2(Sinput)
% 2−Dimensional DOST:
% tic
si = size(Sinput);
D2 coeffM = zeros(si);
D2coeff = zeros(si);
%rows first
for ii = 1:si(1)
    timeseries = Sinput(ii,:);
    D2coeffM(ii,:) = dost(timeseries);
end
for jj = 1:si(2)
    timeseries = D2coeffM(:,jj);
    D2coeff(:,jj) = dost(timeseries);
end

%DecompositionTime = toc
end

