function [h] = idst(S)
%IDST Performs the Inverse Discrete Stockwell Transform
%
%   H = IDST(S) is the inverse of S = DST(H), using the formulation
%   in Stockwell's papers:
%
%       IDST(H) = IFT( SUM S )
%                      tau

N=length(S);

H = sum(S,2);
% Because the frequencies are from -N/2 to N/2-1 in the DST, we need to fftshift first.
h = ifft(fftshift(H));

