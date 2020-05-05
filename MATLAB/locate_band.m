function index = locate_band(p, N)
%LOCATE_BAND gives the indices of an octave in the DOST representation
%   INDEX = LOCATE_BAND(P,N) finds the indices of elements in the P'th octave
%       of a signal of length N in its DOST decomposition. For symmetry purposes,
%       both the positive and negative bands are returned (if they exist)

error(nargchk(2,2,nargin));

if p > log2(N)
    error('octave is too high')
end

% Strictly speaking, the location depends on all the partitions, and how
% it is partitioned. Using the same scheme as in Stockwell's and Yanwei's 
% papers, we can figure it out directly

% zero frequency
if p == 0
    index = N/2+1;
elseif p == log2(N)     % -N/2 frequency
    index = 1;
elseif p == 1
    index = [N/2, N/2+2];
else
    v = 2^(p-1) + 2^(p-2);
    b = 2^(p-1);
    offset = v - b/2;
    index = [N/2+2-offset-b+(0:b-1), N/2+offset+1+(0:b-1)];
end


