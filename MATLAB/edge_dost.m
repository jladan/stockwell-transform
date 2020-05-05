function e = edge_dost(h)
%EDGE detection algorithm based on Hilbert transform (on columns) using DOST instead of FFT

H = sym_fdost(h);
[N,~] = size(h);
n = -N/2:N/2-1;
[~,n] = meshgrid(n,n);

H = i*n.*H;
e = sym_ifdost(H);
