% Function to draw lines on a graph at the band barriers.

function varargout = delineate_bands(N,varargin)
%DELINEATE_BANDS draws a set of lines to hilight bands in a DOST plot
%   H = delineate_bands(N,M,C) draws lines on a set of axes to show where
%       the bands are in a DOST plot. N is the width of the image, M is 
%       the height, and C is a ColorSpec for the colour of the lines.
%       H contains an array of handles to the lines
%
%   H = delineate_bands(N,M) does the above, but with red lines
%
%   H = delineate_bands(N,C) is used for a plot in one dimension. The line
%       height will be N, C is optional
%
%   NOTE: does not yet work for axis indexed by frequency rather than index.

if nargin < 1
    error(nargchk(1,2,nargin));
end

properties = {'color','red'};
if nargin == 1
    height = N;
    M = 0;
elseif isa(varargin{1},'numeric')
    M = varargin{1};
    height = M;
    width = N;
    if nargin > 2
        properties = [properties, varargin{2:end}];
    end
else
    height = N;
    M = 0;
    properties = [properties, varargin];
end

% get the parameters for the bands
[vx,bx] = bands(N);
nx = length(vx);
ny = 0;
if M
    [vy,by] = bands(M);
    ny = length(vy);
end

% initiate the handles vector
h = zeros(nx+ny+2,1);

bstart = 0;
height = height + .5;
for p = 1:nx
    h(p) = line([bstart+.5,bstart+.5],[-0.5,height],properties{:});
    bstart = bstart + bx(p);
end
h(nx+1) = line([bstart+.5,bstart+.5],[-0.5,height],properties{:});

if M
    width = width + .5;
    bstart = 0;
    for p = 1:ny
        h(p+nx+1) = line([-0.5,width],[bstart+.5,bstart+.5],properties{:});
        bstart = bstart + by(p);
    end
    h(nx+ny+2) = line([-0.5,width],[bstart+.5,bstart+.5],properties{:});
else
    h = h(1:end-1);
end

if nargout == 1
    varargout(1) = {h};
end


