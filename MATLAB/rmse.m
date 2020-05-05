function    [rms,e] = rmse(m1,m2)
%RMSE Computes the root mean squared error between to matrices.
%   [RMS, E] = RMSE(M1, M2) returns the root-mean-square error (RMSE)
%   and the error matrix abs(M1-M2)

error(nargchk(2, 2, nargin));

    % Compute the error and mse
    e = abs(m1-m2);
    [N,M] = size(m1);
    rms = sqrt(sum(sum(e.^2))/(M*N));
end
