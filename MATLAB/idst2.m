% A Discrete Stockwell Transform implementation
% given an Nx1 vector, the result is an NxM matrix

function [h] = idst2(S)

N = length(S);
f = transpose(1:N)*ones(1,N);
H = sqrt(2*pi)*ifft(S./f);
h = diag(H)*N;

