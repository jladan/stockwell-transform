% 2D DOST using my multi-row fdost algorithm
% since it is separable, the rows and columns can be done separately.

function D2coeff = fdost2(Sinput)
%FDOST2 Calculates the 2D DOST transform of a matrix
%
%   D2 = FDOST2(H) returns the 2D DOST coefficients calculated using
%   FDOST on the rows, then the columns of H.

error(nargchk(1,1,nargin));

    %rows first
    D2coeffM = fdost(Sinput);
    % Then Columns
    D2coeff = transpose(fdost(transpose(D2coeffM)));

end

