function h = ifdost(S,window)
%IFDOST Performs the Inverse Discrete Orthonormal Stockwell Transform (DOST)
%
%   H = IFDOST(S) performs the Inverse Windowed DOST on each column of S. 
%       This is the corresponding inverse to WDOST

error(nargchk(1,2,nargin));

if nargin == 1
    w = @w_gaussian;
elseif isa(window, 'function_handle')
    w = window;
elseif isa(window, 'char')
    switch window
    case 'gauss',
        w = @w_gaussian;
    case 'hat'
        w = @w_hat;
    case 'box'
        w = @w_box;
    otherwise
        printf('Unknown window %s. Using a gaussian instead\n', window)
        w = @w_gaussian;
    end
end

if size(S,1)==1
    S = S.';
end

    % undo the block transform

    [N,M] = size(S);
    H = zeros(N,M);
    % bands gives the dyadic partitioning of the frequency space
    %    most negative frequencies come first.
    [vs,bs] = bands(N);
    % num is the number of bandwidths
    num = length(vs);

    band_start = 1;
    for j = 1:num
        v = vs(j);
        b = bs(j);

        tau = (0:b-1).';
        if v<0
            tau = flipud(tau);
        end

        ramp = (-1).^tau * ones(1,M);
        tmp(tau+1,:) = S(band_start+(0:b-1),:)./ramp;

        lower = v - floor(b/2) + 1;         % +1 to index at 1 instead of 0
        if lower < 1
            lower = lower + N;              % periodic shift if outside of vector bounds
        end
        
        g = w(b) * ones(1,M);
        if v<0
            g = flipud(g);
            H(lower+(0:b-1),:) = circshift( fft( tmp/sqrt(b) ,[],1), [-1,0]) ./ g;
        else
            H(lower+(0:b-1),:) = fft( tmp/sqrt(b),[],1 ) ./ g;
        end

        band_start = band_start + b;
        % because of the way we're defining tmp above, it has to be cleared every time
        clear tmp;
    end

    h = ifft(H);
end

function w = w_gaussian(N)
    % a once-folded gaussian window
    % The width is chosen to correspond to f = v = 3/2*b
    % in the standard Stockwell Transform

    % The result is close enough to 1 for N=1 to suit my needs.
    vector(1,:)=[0:N-1];
    vector(2,:)=[-N:-1];
    vector=vector.^2;    
    vector=vector*(-8/9*pi^2/N^2);
    % Compute the Gaussion window
    w=transpose(sum(exp(vector)));

end

function w = w_hat(N)
    if N == 1
        w = 1;
    else
        N = N/2;
        w = 1 - abs( (-N:N-1)+.5 )/N;
    end
    w = w.';
end

function w = w_box(N)
    w = ones(N,1);
end

