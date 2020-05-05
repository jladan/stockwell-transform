function h = sym_ifdost(S)
%SYM_IFDOST Performs the Inverse Discrete Orthonormal Stockwell Transform (DOST)
%
%   H = SYM_IFDOST(S) performs the IDOST on each row of S. This is the corresponding
%       inverse to FDOST

error(nargchk(1,1,nargin));

    % undo the block transform

    [N,M] = size(S);
    H = zeros(N,M);
    k = (0:N-1).';

    % bands gives the dyadic partitioning of the frequency space
    %    most negative frequencies come first.
    [v,b] = sym_bands(N);
    % num is the number of bandwidths
    num = length(v);

    band_start = 1;
    for p = 1:num
        % values of tau on the band (in a column vector)
        tau = (0:(b(p)-1)).';
        % For symmetry of coefficients, they are in reverse order for 
        %   the negative frequency bands
        if v(p)<0
            tau = flipud(tau);
        end


        lower = band_start;
        upper = lower + b(p)-1;

        % The ramp "diagonal matrix"
        ramp = ((-1).^tau) * ones(1,M) ;           % exp(-i*pi*tau) = (-1)^tau
        % the second ramp (shifting back by 1/2)
        ramp2 = exp(-i*pi*tau/b(p)) * ones(1,M);
        
        tmp(tau+1,:) = S(lower:upper,:).*ramp.*ramp2;

        % Undo the local ifft
        H(lower:upper,:) = fft( tmp/sqrt(b(p)),[],1 );

        band_start = band_start + b(p);
        % because of the way we're defining tmp above, it has to be cleared every time
        clear tmp;
    end

    % Shift bands back to matlab's preference
    H = circshift(H, [1-N/2,0]);
    % now, undo the IFFT and 1/2 shift
    ramp = exp(-i*pi*k/N) * ones(1,M);
    h = ifft(H).*ramp;

    % done!

end


