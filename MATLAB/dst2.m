function [S] = dst2(h)
%DST2 computes the 2D version of the Discrete Stockwell Transform
%   S = DST2(H) returns the discrete stockwell transform of the image H
%   This implementation uses a once-folded gaussian window
%   S contains both negative and positive frequencies

error(nargchk(1,1,nargin))

% Initialize data
[N,M] = size(h);

% Start the actual algorithm
H = fft2(h);

% The 2D DST is done in n_y, n_x, k_y, k_x
% where k is the wave number, and n is the spatial coordinate
% The reason for this is that the computational method favours Contiguous blocks 
% of memory for spatial coordinates
% And, technically, Matlab orders by y,x for image indices (however, this does not affect the algorithm)
S = zeros(N,M,N,M,'single');

% The zero frequency voices are calculated with 1D dst.
% Since the DST results in H(k_x,x), we take the transpose
tmp_dst = dst(sum(h,1)/N).';
for n = 1:N
    S(n,:,N/2+1,:) = reshape(tmp_dst,1,M,1,M); % reshape to be safe, though it seems unnecessary
end
tmp_dst = dst(sum(h,2)/M).';
for m = 1:M
    S(:,m,:,M/2+1) = reshape(tmp_dst,1,M,1,M); % reshape to be safe, though it seems unnecessary
end

% The middle value should be the average, but just to be safe
S(:,:,N/2+1,M/2+1) = sum(h(:))/(N*M);


% I'm not using all the fanciness, 'cause wtf!
range_kx = [(-N/2:-1) , 1:(N/2-1)];
range_ky = [(-M/2:-1) , 1:(M/2-1)];

for kx = range_kx
    for ky = range_ky
        gx = g_window(kx,N).' * ones(1,M,'single') ;
        gy = ones(N,1,'single') * g_window(ky,M) ;
        S(:,:, kx+N/2+1, ky+M/2+1) = ifft2( circshift(H,[-kx -ky]) .* gx.*gy );
    end
end


end

% The following creates a once folded gaussian in a row vector.
function gn = g_window(n,N);
    m = 0:N-1;
    gn = exp(-2*pi^2 * m.^2 / n^2);
    gn = gn + exp(-2*pi^2 * (m-N).^2 / n^2);
end

