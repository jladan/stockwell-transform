function [S1,S2] = safe_dost(h)
%SAFE_DOST calculates the DOST using inner products rather than FFT's.
%   This function is to be used for testing implementations of the FDOST
%
%   [S1, S2] = SAFE_DOST(H) returns the DOST of H calculated by inner products with
%       basis vectors obtained from DOST_BASIS. S1 is the safest value, and S2
%       is calculated from the analytic sum formulation of the basis vectors

error(nargchk(1,1,nargin));

    % first, get the various parameters.
    N = length(h);
    [vs,bs] = sym_bands(N);     % params. of partitions of the frequency domain
    num = length(vs);

    % k is the time index of the signal
    k = 0:N-1;

    % now on each combination of v,b,tau, we find the basis vector, and take the inner product
    j = 1;
    for p = 1:num
        v = vs(p);
        b = bs(p);

        % range is the range of values for tau
        range = 0:b-1;
        % Negative frequencys are indexed in reverse for symmetry
        if v<0
            range = fliplr(range);
        end

        for tau = range
            % calculate the basis vector
            [d1,d2] = dost_basis(v,b,tau,N);

            % now, do the inner product
            S1(j) = sum( h.*conj(exp(-i*pi*(k/N-tau/b)) .* d1) );
            S2(j) = sum( h.*conj(exp(-i*pi*(k/N-tau/b)) .* d2) );
            j = j + 1;
        end
    end

end

