function D2coeff = sym_fdost2(Sinput)
%SYM_FDOST2 Calculates the 2D SymDOST transform of a matrix
%
%   D2 = SYM_FDOST2(H) returns the 2D DOST coefficients calculated using
%   SYM_FDOST on the columns, then the rows of H.

error(nargchk(1,1,nargin));

    % columns first
    D2coeffM = sym_fdost(Sinput);
    % Then rows
    D2coeff = transpose(sym_fdost(transpose(D2coeffM)));

end

