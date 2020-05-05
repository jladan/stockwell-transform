% My own implemenation of Yanwei's Fast DOST transform (in 1D)

% Input: S -- DOST of the signal

function h = ifdost(S)
    % undo the block transform

    N = length(S);
    H = zeros(1,N);
    % bands gives the dyadic partitioning of the frequency space
    %    most negative frequencies come first.
    [vs,bs] = bands(N);
    % num is the number of bandwidths
    num = length(vs);

    band_start = 1;
    for j = 1:num
        v = vs(j);
        b = bs(j);

        tau = 0:b-1;
        if v<0
            tau = fliplr(tau);
        end

        ramp = (-1).^tau;
        tmp(tau+1) = S(band_start+(0:b-1))./ramp;

        lower = v - floor(b/2) + 1;         % +1 to index at 1 instead of 0
        if lower < 1
            lower = lower + N;              % periodic shift if outside of vector bounds
        end
        if v<0
            H(lower+(0:b-1)) = circshift( fft( tmp/sqrt(b) ), [0,-1]);
        else
            H(lower+(0:b-1)) = fft( tmp/sqrt(b) );
        end

        band_start = band_start + b;
        % because of the way we're defining tmp above, it has to be cleared every time
        clear tmp;
    end

    h = ifft(H);
end


