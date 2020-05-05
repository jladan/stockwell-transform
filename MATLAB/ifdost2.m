function output = ifdost2(D2coeff)
%IFDOST2 Performs the 2D Inverse DOST
%
%   H = IFDOST2(S) returns the IDOST of S

error(nargchk(1,1,nargin));

    % 2−Dimensional Inverse FDOST:
    % done in reverse order as fdost2 (hoping for better accuracy)
    intermediate = transpose(ifdost(transpose(D2coeff)));
    output = ifdost(intermediate);
end

