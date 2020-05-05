% Function which does a simple compression algorithm on data

% inputs:   data    fourier/dost/wavelet data
%           p       percentage of coefficients to keep
% outputs:  comp    "compressed" data
%           ap      actual percentage of coefficients kept

function    [comp,ap] = compress(data, p, sorh)
%COMPRESS Performs a thresholding/compression on the data
%   [comp, ap] = compress(data, p) thresholds the data to keep the fraction p
%   of the points, setting all others to zero. 'comp' is the compressed data, and
%   'ap' is the actual fraction of data kept.

error(nargchk(2,3,nargin));

if not(exist('sorh'))
    sorh='h';
end

    % first, analyze the data
    adata = abs(data);
    % get the unique values
    unv = unique(adata);
    unv = unv(1:2:end); % remove half the numbers to speed up
    % now, count the number of each value
    count = histc(adata(:),unv);
    % normalized cumulative sum
    cs = cumsum(count);
    cs = cs/cs(end);

    % Find the index for the value which is greater than (1-p)% of other values
    j = find(cs>(1-p));
    j = j(1);

    % set all coefficients less that unv(j) to 0
    comp = thresh(data, unv(j), sorh);
    ap = 1 - cs(j);
end



