function [comps, aps, files] = compression_tests(data, ps, trans, inv, measures, fileN)
%COMPRESSION_TESTS runs a series of thresholdings on the data (in the transformed space)
%
%   [comps, aps, files] = compression_tests(data, ps, trans, inv, measures, fileN)
%       runs the test on the matrix 'data', compression rates 'ps', using the transform
%       'trans' (a function handle), and its inverse 'inv'. Returning:
%
%       'comps' - a cell array with each cell a vector corresponding to the measure of
%               the compressed data vs. the original data
%       'aps'   - the actual compression rates achieved
%       'files' - the list of image files created (using fileN as the root name)
%
%   [comps, aps, images] = compression_tests(data, ps, trans, inv, measures)
%       If no file name is given, the compressed image data will be returned instead
%       of the file names. This way, figures can be constructed in matlab.
%

% run a bunch of compression tests

% inputs    data    transformed data to be compressed
%           ps      vector containing percentage of coeff. to keep
%           trans   forward transform to apply before compression
%           inv    inverse transform to create image
%           fileN   root file name
%           measures    function handles of the comparison tests (cell array)

error(nargchk(5,6,nargin))
if nargin < 6
    fileN = 0;
end

    % and, begin
    comps = cell(size(measures));
    files = {};
    aps = [];
    tdata = trans(data);
    for p = ps
        [c,ap] = compress(tdata,p);
        aps = [aps;ap];
        imData = real(inv(c));
        for j = 1:length(measures)
            m = measures{j};
            comps{j} = [comps{j};m(im2uint8(data), im2uint8(imData))];
        end
        if fileN
            files = [files, strcat(fileN,num2str(ap*100,2),'.png')];
            imwrite(imData, files{end}, 'png','bitdepth',8);
        else
            files = [files, imData];
        end
    end
