function D2coeff = wdost2(Sinput,varargin)
%WDOST2 Calculates the 2D WinDOST transform of a matrix
%
%   D2 = WDOST2(H) returns the 2D DOST coefficients calculated using
%   wDOST on the columns, then the rows of H.
%
%   D2 = WDOST2(H,window) returns the 2D DOST coefficients calculated using
%   WDOST with window 'window' on the columns, then the rows of H.

error(nargchk(1,2,nargin));

    % columns first
    D2coeffM = wdost(Sinput,varargin{:});
    % Then rows
    D2coeff = transpose(wdost(transpose(D2coeffM), varargin{:}));

end

