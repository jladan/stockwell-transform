function h = entropy(x,n)
%ENTROPY Computes a first-order estimate of the entropy of a matrix 
%   H = ENTROPY(X) computes the Shannon Entropy of a matrix.
%       The contents in X are not quantized in any way in this routine.
%       This way, various quantizations can be performed and tested to
%       compare the quality of compression.

error(nargchk(1,1,nargin));

if not(exist('n'))
    n = 255;
end

xh = hist(x(:),n);   % count the number of each unique value
xh = xh/sum(xh(:));     % compute probabilities

i = find(xh);           % mask to remove zeros

% now the entropy
h = -sum(xh(i) .* log2(xh(i)));
