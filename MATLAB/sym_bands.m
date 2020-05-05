function [v,b] = sym_bands(N)
%BANDS Computes the parameters for a dyadic SymDOST
%   Discerned from Y. Wang's FDOST paper.
%
%   [v, b] = bands(N) provides a dyadic partitioning of the frequency domain
%   where v is a vector consisting of the centres of each partition, and
%   b is a vector of the corresponding bandwidths
%
%   The band centres are given values relative to the original signal (not
%   the 1/2-shifted one).

error(nargchk(1,1,nargin));

    n=log2(N);
    if not( round(n) == n )
        error('Current implementation of DOST requires 2^n data points');
    end

    % Initialize the positive and negative bandwidth parameters
    %   The positive and negative frequencies are treated differently
    %   in order to maintain conj. symmetry for the original DOST
    %   These will be joined together at the end.
    pos_v = zeros(1,n);
    pos_b = zeros(1,n);
    neg_v = zeros(1,n);
    neg_b = zeros(1,n);

    % The one band is a special case
    pos_v(1) = 0.5;
    pos_b(1) = 1;
    neg_v(1) = -0.5;
    neg_b(1) = 1;

    % As are the +1 and -1 bands
    pos_v(2) = 1.5;
    pos_b(2) = 1;
    neg_v(2) = -1.5;
    neg_b(2) = 1;

    % The rest of the bands are determined by the following
    %  where p is the corresponding octave of each band
    for p = 3:n
        pos_v(p) = 2^(p-2) + 2^(p-3);
        pos_b(p) = 2^(p-2);
        neg_v(p) = -pos_v(p);
        neg_b(p) = pos_b(p);
    end

    % Finally the negative bands are reversed, 
    %   and positive ones concatenated onto them
    v = [fliplr(neg_v),pos_v];
    b = [fliplr(neg_b),pos_b];
end
