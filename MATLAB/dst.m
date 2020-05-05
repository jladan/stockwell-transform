function [S] = dst(h)
%DST Is my own implementation of the Discrete Stockwell Transform
%   S = DST(H) returns the discrete stockwell transform of the signal H
%   This implementation uses a once-folded gaussian window
%   S contains both negative and positive frequencies

error(nargchk(1,1,nargin))

% Initialize data
[N,M] = size(h);
% convert to row vector
if N==1
    N = M;
elseif M==1
    h = h.';
else
    error('must be a row or column vector')
end
S = zeros(N,N);

% Start the actual algorithm
H = fft(h);
H = [H,H];

% The zero frequency voice is the mean sum
S(N/2+1,:) = sum(h)/N;

% Now for the actual DS
for n = 1:N/2-1
    gn = g_window(n,N);
    S(N/2+n+1,:) = ifft(gn .* H(n+1:n+N));
end

for n = -N/2:-1
    gn = g_window(n,N);
    S(N/2+n+1,:) = ifft(gn .* H(N+n+1:2*N+n));
end






end

% The following creates a once folded gaussian in a row vector.
function gn = g_window(n,N);
    m = 0:N-1;
    gn = exp(-2*pi^2 * m.^2 / n^2);
    gn = gn + exp(-2*pi^2 * (m-N).^2 / n^2);
end

