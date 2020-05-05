function h = iwdost2(S, varargin)
%IWDOST2 Calculates the 2D SymDOST transform of a matrix
%
%   D2 = IWDOST2(H) returns the 2D DOST coefficients calculated using
%   wDOST on the columns, then the rows of H.

error(nargchk(1,2,nargin));

    % rows first
    D2coeffM = transpose(iwdost(transpose(S),varargin{:}));
    % Now columns
    h = iwdost(D2coeffM,varargin{:});

end

