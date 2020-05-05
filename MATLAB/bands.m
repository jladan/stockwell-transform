% Function to determine the band parameters for conj. sym. octave DOST

% input: N is the length of a signal, assumed to be 2^n
function [v,b] = bands(N)
%BANDS Computes the parameters for a conjugate symmetric dyadic DOST
%   As defined in Stockwell's original DOST paper (2006)
%
%   [v, b] = bands(N) provides a dyadic partitioning of the frequency domain
%   where v is a vector consisting of the centres of each partition, and
%   b is a vector of the corresponding bandwidths

error(nargchk(1,1,nargin));

    n=log2(N);

    % Initialize the positive and negative bandwidth parameters
    %   The positive and negative frequencies are treated differently
    %   in order to maintain conj. symmetry for the original DOST
    %   These will be joined together at the end.
    pos_v = zeros(1,n);
    pos_b = zeros(1,n);
    neg_v = zeros(1,n);
    neg_b = zeros(1,n);

    % The zero band is a special case
    pos_v(1) = 0;
    pos_b(1) = 1;

    % As are the +1 and -1 bands
    pos_v(2) = 1;
    pos_b(2) = 1;
    neg_v(1) = -1;
    neg_b(1) = 1;

    % The rest of the bands are determined by the following
    %  where p is the corresponding octave of each band
    for p = 2:n-1
        pos_v(p+1) = 2^(p-1) + 2^(p-2);
        pos_b(p+1) = 2^(p-1);
        neg_v(p) = -2^(p-1) - 2^(p-2) + 1;
        neg_b(p) = 2^(p-1);
    end

    % except the most-negative frequency is special
    neg_v(n) = -2^(n-1);
    neg_b(n) = 1;

    % Finally the negative bands are reversed, 
    %   and positive ones concatenated onto them
    v = [fliplr(neg_v),pos_v];
    b = [fliplr(neg_b),pos_b];
end
