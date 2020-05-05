% My own implemenation of Yanwei's Fast DOST transform (in 1D)

% Input: h -- signal assumed to be a row vector of length 2^n

function S = fdost(h)

    % first, we take the FFT of the signal
    H = fft(h);

    % next the block-diagonal transform
    % The values we need are: 
    %   v - each unique frequency centre ordered from most negative to most positive (vector of length num)
    %   b - bandwidth of the corresponding v (vector of length num)
    %   num - number of bands   (single value)
    %   band_start - start of current band in the S vector


    N = length(h);
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
            tmp = sqrt(b) * ifft(circshift(H(lower:upper),[0,1]));
        else
            tmp = sqrt(b) * ifft(H(lower:upper));
        end

        % The ramp "diagonal matrix"
        ramp = (-1).^tau;           % exp(-i*pi*tau) = (-1)^tau

        % apply the ramp to the ifft, and assign to corresponding values in S
        S(band_start+(0:b-1)) = ramp.*tmp(tau+1);

        % determine start of next band
        band_start = band_start + b;
    end
end
