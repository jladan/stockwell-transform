% returns the DOST basis vector (calculated 2 ways)

% inputs: v,b,tau and N=length
function [d1,d2] = dost_basis(v, b, tau, N)
%DOST_BASIS Computes the DOST basis vector for a set of parameters
%
%   [d1,d2] = dost_basis(v, b, tau, N) calculates the basis vector
%       of length N, corresponding to parameters v, b, and tau.
%       The calculation is done by a linear combination for 'd1' and
%       the analytic sum for 'd2'.
%
%   NOTE: for some values of 'b', the analytic sum does not provide the
%         correct values

error(nargchk(4,4,nargin))

    % time index
    k = 0:(N-1);

    % calculate basis based on a linear combination 
    %   This is the original definition in Stockwell's paper.
    d1 = zeros(1,N);
    lower = v-floor(b/2);
    for f = lower:(lower+b-1)
        d1 = d1 + exp(i*2*pi*k*f/N)*exp(-i*2*pi*tau*f/b);
    end
    d1 = d1*exp(-i*pi*tau)/sqrt(b);
    
    % calculate the same vector but with analytic sum of the above
    %   Note that this does not work correctly in some cases (eg. b=1)
    d2 = exp(-i*2*pi*(k/N - tau/b)*(v-b/2-1/2));
    d2 = d2 - exp(-i*2*pi*(k/N - tau/b)*(v+b/2-1/2));
    d2 = d2*i*exp(-i*tau*pi)./(sqrt(b)*2*sin(pi*(k/N-tau/b)));

end

