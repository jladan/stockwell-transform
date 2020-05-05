function    [W,vxs,vys,bxs,bys] = localSpectrum(s, x, y, sym)
%LOCAL_SPECTRUM Calculates the local spectrum at a point in an image from the DOST
%
%   [W, vx,vy,bx,by] = local_spectrum(S, X, Y, sym) returns a log(N) X log(M) matrix
%       containing the local spectrum at (X,Y) given the NxM matrix S containing
%       the DOST coefficients of an image. If sym == 'sym', then the SymDOST bands
%       are used.
%
%       W       is the local spectrum matrix
%       vx,vy   are the centres of the bands (ie. frequencies)
%       bx,by   are the bandwidths associated with each vx,vy
%
%   The local spectrum is calculated based on the paper by Drabycz:
%   "Image Texture Characterization Using the Discrete Orthonormal S-Transform"
%   Here, each band (vx,vy) represents a part of the spectrum, and the coefficient
%   corresponding to (tau_x = b_x * x / N, tau_y = b_y * y / M) is the value of the
%   local frequency.

error(nargchk(3,4,nargin));

    % First, we need the bandwidth partitioning of the spectrum
    [N,M] = size(s);
    if exist('sym','var')
        [vxs,bxs] = sym_bands(M);
        [vys,bys] = sym_bands(N);
    else
        [vxs,bxs] = bands(M);
        [vys,bys] = bands(N);
    end

    numx = length(vxs);
    numy = length(vys);
    W = zeros(numy,numx);
    % Scan all the bands
    bandx = 1;
    for px = 1:numx
        vx = vxs(px);
        bx = bxs(px);
        
        % Determine taux from from the window centre
        taux = round(bx*x/M);
        if vx<0
            taux = bx-taux;      % tau in reverse order for negative bands
        end
        taux = mod(taux, bx);    % keep taux in bounds

        bandy = 1;
        for py = 1:numy
            vy = vys(py);
            by = bys(py);

            % Determine tauy from from the window centre
            tauy = round(by*y/M);
            if vy<0
                tauy = by-tauy;      % tau in reverse order for negative bands
            end
            tauy = mod(tauy, by);    % keep tauy in bounds

            W(py,px) = s(bandy+tauy,bandx+taux);
            bandy = bandy + by;
        end
        bandx = bandx + bx;
    end



