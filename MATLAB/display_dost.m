% Uses patches in matlab to display the 1D DOST as a t-f representation

%input:     s = dost data (previously made real, imag, abs, etc.)
%output:    h = handle to patch

function    h = showDost_smart(s,vs,bs)
% DISPLAY_DOST Displays the time-frequency distribution of a DOST vector
%   h = display_dost(s) clears the current figure, and displays the time-frequency
%       distribution associated with the DOST decomposition 's'
%
%   If 's' is a real-valued vector, then the values in 's' are used for the intensities
%   If 's' is complex-valued, then the values abs(s) are used.

error(nargchk(1,3,nargin));

[N,M] = size(s);
if N == 1
    N = M;
elseif M==1
    s = s.';
else
    error('only vectors allowed for display_dost');
end

if nargin == 1
    [vs,bs]= bands(N);
elseif nargin ==2
    error('must specify both band parameters');
end



    % clear the figure
    fig = gcf();
    clf(fig);
    figure(fig);

    % if the data is complex, take the modulus
    if not(isreal(s))
        s = abs(s);
    end

    % Next, create the X and Y values for all the faces
    X=[];
    Y=[];
    C=[];
    band_start = 1;
    for j = 1:length(vs)
        v = vs(j);
        b = bs(j);
        tau = 0:b;

        % y is easy, since it's prescribed entirely by v and b
        lower = v-b/2 * ones(1,b+1);
        upper = lower+b * ones(1,b+1);
        y = [lower;upper;upper;lower];

        % x is more complicated, since we have to go through tau
        left = tau*N/b - N/(2*b);
        right = left+ N/b;
        left(1)=0;
        right(b+1)=N;
        x = [left;left;right;right];

        Y = [Y,y];
        X = [X,x];
        c = s(band_start+(0:b-1));
        if v<0
            c = fliplr(c);
        end
        C = [C,c,c(1)];

        band_start = band_start+b;
    end

    % Now make the patch
    % note that s corresponds to the CData which will be mapped by the ColorMap
    h = patch(X,Y,C,'LineStyle','none');

    % set reasonable axis bounds
    axis([0,N,-N/2,N/2])

end



