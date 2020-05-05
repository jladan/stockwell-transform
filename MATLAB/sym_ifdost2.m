function h = sym_ifdost2(S)
%SYM_FDOST2 Calculates the 2D SymDOST transform of a matrix
%
%   D2 = SYM_FDOST2(H) returns the 2D DOST coefficients calculated using
%   SYM_FDOST on the columns, then the rows of H.

error(nargchk(1,1,nargin));

    % rows first
    D2coeffM = transpose(sym_ifdost(transpose(S)));
    % Now columns
    h = sym_ifdost(D2coeffM);

end

