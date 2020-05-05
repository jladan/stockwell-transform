function    odata = threshold(data, t, sorh)
%THRESH Performs a thresholding on the data
%   [t] = thresh(data, t, SORH) thresholds the data at value t
%           if SORH == 'h', a hard thresholding is performed
%           otherwise, a soft thresholding is done

error(nargchk(2,3,nargin));

    % first, analyze the data
    adata = abs(data);

    % set all coefficients less than t to 0
    data(adata<t) = 0;

    if not(exist('sorh')) || (sorh == 's')
        data = data .* (1-t./adata);
    end

    odata = data;

end



