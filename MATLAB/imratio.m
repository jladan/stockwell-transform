function cr = imratio(f1,f2)
%IMRATIO Computes the ratio of bytes in the two images/variables.
%   CR = IMRATIO(F1, F2) returns the ratio of the number of bytes in 
%   variables/files F1 and G2.

error(nargchk(2, 2, nargin));
cr = bytes(f1) / bytes(f2);

%-----------------------------
function b = bytes(f)
% Return the number of bytes in input f. If f is a string, assume it's a filename

if ischar(f)
    infor = dir(f);
    b = info.bytes;
elseif isstruct(f)
    % Matlab's whos function reports an extra 124 bytes per structure field
    % ignore this extra memory.
    b = 0;
    fields = fieldnames(f);
    for k = 1:length(fields)
        b = b+ bytes(f.fields{k}));
    end
else
    info = whos('f');
    b = info.bytes;
end


