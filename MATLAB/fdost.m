% My own implemenation of Yanwei's Fast DOST transform (in 1D)
% I derived it myself to ensure correctness of implementation
% It has been tested against an inner product based DOST transform

% MULTI-ROW VERSION
% Input: h -- a matrix, with signals along the rows assumed length 2^n

function S = fdost(h)
%FDOST Computes the 1D DOST on each row of a matrix
%
%   S = FDOST(H) returns the 1D DOST on each row of the matrix H,
%       using the conjugate symmetric dyadic basis described in 
%       Stockwell's 2006 paper and Y. Wang's papers. (ie. basis vectors
%       are not shifted by 1/2)

error(nargchk(1,1,nargin));

    % first, we take the FFT of the signals
    H = fft(h,[],2);

    % next the block-diagonal transform
    % The values we need are: 
    %   v - each unique frequency centre ordered from most negative to most positive (vector of length num)
    %   b - bandwidth of the corresponding v (vector of length num)
    %   num - number of bands   (single value)
    %   band_start - start of current band in the S vector


    [M,N] = size(h);
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
        tau = 0:(b-1);
        % For symmetry of coefficients, they are in reverse order for 
        %   the negative frequency bands
        if v<0
            tau = fliplr(tau);
        end

        % Find the local IFFT on the band, multiplied by sqrt(b) for normalization
        % 0-frequency component is at H(1)
        lower = v - floor(b/2) + 1;         % +1 to index at 1 instead of 0
        if lower < 1
            lower = lower + N;              % periodic shift if outside of vector bounds
        end
        upper = lower + b - 1;
        if v<0
            % Shifting by 1 before the IFT corrects the phase
            tmp = sqrt(b) * ifft(circshift(H(:,lower:upper),[0,1]),[],2);
        else
            tmp = sqrt(b) * ifft(H(:,lower:upper),[],2);
        end

        % The ramp "diagonal matrix"
        ramp = ones(M,1) * ((-1).^tau);           % exp(-i*pi*tau) = (-1)^tau

        % apply the ramp to the ifft, and assign to corresponding values in S
        S(:,band_start+(0:b-1)) = ramp.*tmp(:,tau+1);

        % determine start of next band
        band_start = band_start + b;
    end
end
