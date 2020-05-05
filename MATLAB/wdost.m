function S = wdost(h,window)
% FDOST Computes the 1D Windowed DOST on each column of a matrix
%
%   S = WDOST(H) returns the 1D Windowed DOST on each column of the matrix H,
%       using a Gaussian window, and the conjugate symmetric dyadic basis 
%       described in Stockwell's 2006 paper and Y. Wang's papers. 
%       (ie. basis vectors are not shifted by 1/2)
%
%   S = WDOST(H,window_name) can be used to specify the window. From
%       some preset values:
%           'box'   original DOST
%           'hat'   hat function for each partition
%           'gauss' gaussian
%
%   S = WDOST(H,window) performs the Windowed DOST using the window function
%       passed as a handle. window functions take a length, and return a column
%       vector of that length, with sum = 1.

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

if size(h,1)==1
    h = h.';
end


    % first, we take the FFT of the signals
    H = fft(h,[],1);

    % next the block-diagonal transform
    % The values we need are: 
    %   v - each unique frequency centre ordered from most negative to most positive (vector of length num)
    %   b - bandwidth of the corresponding v (vector of length num)
    %   num - number of bands   (single value)
    %   band_start - start of current band in the S vector


    [N,M] = size(h);
    % bands gives the dyadic partitioning of the frequency space
    %    most negative frequencies come first.
    [vs,bs] = bands(N);
    % num is the number of bandwidths
    num = length(vs);

    band_start = 1;
    for j=1:num
        v = vs(j);
        b = bs(j);
        % values of tau on the band
        tau = transpose(0:(b-1));
        % For symmetry of coefficients, they are in reverse order for 
        %   the negative frequency bands
        if v<0
            tau = flipud(tau);
        end

        % Find the local IFFT on the band, multiplied by sqrt(b) for normalization
        % 0-frequency component is at H(1)
        lower = v - floor(b/2) + 1;         % +1 to index at 1 instead of 0
        if lower < 1
            lower = lower + N;              % periodic shift if outside of vector bounds
        end
        upper = lower + b - 1;
        
        % Apply the window
        g = w(b);
        if v<0
            % for symmetry, the negative frequency windows should be reversed
            g = flipud(g);
            tmp = H(lower:upper,:) .* (g*ones(1,M));
            % Shifting by 1 before the IFT corrects the phase
            tmp = sqrt(b) * ifft(circshift(tmp,[1,0]),[],1);
        else
            tmp = H(lower:upper,:) .* (g*ones(1,M));
            tmp = sqrt(b) * ifft(tmp,[],1);
        end

        % The ramp "diagonal matrix"
        ramp = ((-1).^tau) * ones(1,M);           % exp(-i*pi*tau) = (-1)^tau

        % apply the ramp to the ifft, and assign to corresponding values in S
        S(band_start+(0:b-1),:) = ramp.*tmp(tau+1,:);

        % determine start of next band
        band_start = band_start + b;
    end
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
    w = fftshift(w);
end

function w = w_box(N)
    w = ones(N,1);
end
