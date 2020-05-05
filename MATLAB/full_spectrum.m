function    [W,vxs,vys,bxs,bys] = localSpectrum(s, sym)
%FULL_SPECTRUM Calculates the local spectrum at each point in an image from the DOST
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

error(nargchk(1,2,nargin));

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
    W = zeros(N,M,numy,numx, 'single');
    tmp = zeros(N,M,'single');
    % Scan all the bands
    bandx = 1;
    for px = 1:numx
        vx = vxs(px);
        bx = bxs(px);
        
        bandy = 1;
        for py = 1:numy
            vy = vys(py);
            by = bys(py);

            % Now, we have to go through each value of taux and tauy in the band
            tauxs = 0:bx-1;
            tauys = 0:by-1;
            if vx < 0
                tauxs = fliplr(tauxs);
            end
            if vy < 0
                tauys = fliplr(tauys);
            end

            for taux = tauxs
                for tauy = tauys
                    % upper and lower bounds in space domain of this coefficient
                    Lx = M/bx*taux + 1;
                    Ux = M/bx + Lx - 1;
                    Ly = M/by*tauy + 1;
                    Uy = M/by + Ly - 1;

                    tmp(Ly:Uy, Lx:Ux) = s(bandy+tauy,bandx+taux);
                end
            end

            % The centres of all the blocks have to be shifted, since
            % they're currently off by N/(2*by), M/(2*bx)
            W(:,:,py,px) = circshift(tmp, [-N/2/by, -M/2/bx]);


            bandy = bandy + by;
        end
        bandx = bandx + bx;
    end



