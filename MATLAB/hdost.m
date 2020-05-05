function S = hdost(h)
%HDOST Computes the 1D Hartley DOST on each column of a matrix
%
%   S = HDOST(H) returns the 1D Hartley DOST on each row of the matrix H,
%       using my own idea

error(nargchk(1,1,nargin));

    % Determine properties of signal, and set up some parameters
    [N,M] = size(h);
    k = (0:N-1).';
    S = zeros(size(h));

    % now, get the HT of the signal, and shift it 
    % in a good way for book keeping (lowest frequency band
    % starts at H(1)
    H = fht(h);
    H = circshift(H, [N/2-1,0]);

    % next the block-diagonal transform
    % The values we need are: 
    %   v - each unique frequency centre ordered from most negative to most positive (vector of length num)
    %   b - bandwidth of the corresponding v (vector of length num)
    %   num - number of bands   (single value)
    %   band_start - start of current band in the S vector


    % bands gives the dyadic partitioning of the frequency space
    [v,b] = bands(N);
    % num is the number of bandwidths
    num = length(v);

    band_start = 1;
    for p=1:num
        % values of tau on the band (in a column vector)
        tau = (0:(b(p)-1)).';
        % For symmetry of coefficients, they are in reverse order for 
        %   the negative frequency bands
        if v(p)<0
            tau = flipud(tau);
        end

        % Due to the indexing arranged when the FFT was calculated,
        % frequencies line up with the DOST
        lower = band_start;
        upper = lower + b(p)-1;
        tmp = fht(H(lower:upper,:)) / sqrt(b(p)) ;
        S(lower:upper,:) = tmp(tau+1,:);

        % determine start of next band
        band_start = band_start + b(p);
    end

end
