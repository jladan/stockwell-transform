function D2coeff = fdost2(Sinput)
% 2−Dimensional DOST:
% tic
[N,M] = size(Sinput);
D2coeffM = zeros(N,M);
D2coeff = zeros(N,M);
%rows first
for n = 1:M
    timeseries = Sinput(n,:);
    D2coeffM(n,:) = fdost(timeseries);
end
for m = 1:N
    timeseries = transpose(D2coeffM(:,m));
    D2coeff(:,m) = transpose(fdost(timeseries));
end

%DecompositionTime = toc
end

