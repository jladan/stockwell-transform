% calculates the peak signal to noise of two matrices

% inputs    s1  signal 1
%           s2  signal 2
% outputs   p   peak signal to noise ratio
function    p = psnr(s1,s2)
%PSNR caclulates the peak signal to noise ratio of an image
%
%   P = PSNR(ORIGINAL, MODIFIED) returns P: the psnr of the MODIFIED
%       image compared to the ORIGINAL
%
%   for now, the image is assumed to be a normalized double representation

error(nargchk(2,2,nargin));

    % For images which are doubles, the max is 1.0 (in theory)
    p = -10 * log10(mse(s1,s2));     % 20*log10(max) - 10*log10(mse(s1,s2))
end
