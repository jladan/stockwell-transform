function [e,eh,ev] = edge(h)
%EDGE detection algorithm based on Hilbert transform
%
%   Performs horizontal and vertical edge detection simultaneously

H = fft(h,[],1);
[N,~] = size(h);
n = -N/2:N/2-1;
[~,n] = meshgrid(n,n);
n = circshift(n,[N/2,0]);

H = i*n.*H;
ev = ifft(H,[],1);

H = fft(h,[],2);
[~,N] = size(h);
n = -N/2:N/2-1;
[n,~] = meshgrid(n,n);
n = circshift(n,[0,N/2]);

H = i*n.*H;
eh = ifft(H,[],2);

e = abs(eh) + abs(ev);
