% A Gabor transform of width f
% given an Nx1 vector, the result is an NxM matrix

function [G] = gabor(h,s)
%GABOR Calculates the gabor transform of a vector
%
%   G = GABOR(H, S) returns an NxN matrix G containing the Gabor Transform
%   of the length N matrix H, using a gaussian window of width S.

N=length(h);
NFFT=2^nextpow2(N);

m = 0:(NFFT-1);
h = padarray(h,[0,NFFT-N],'post');

G = zeros(NFFT);
for t = 0:(NFFT-1)
  gauss=exp(-(m-t).^2/s^2/2);
  G(:,t+1)= fft(gauss.*h,NFFT);
end




