function output = fdost2(D2coeff)
% 2−Dimensional DOST:
% tic
[N,M] = size(D2coeff);
D2coeffM = zeros(N,M);
output = zeros(N,M);
%rows first
for m = 1:M
    dost_series = D2coeff(m,:);
    D2coeffM(m,:) = ifdost(dost_series);
end
for n = 1:N
    dost_series = transpose(D2coeffM(:,n));
    output(:,n) = transpose(ifdost(dost_series));
end

%DecompositionTime = toc
end

