function h = signal(t,sig_name,varargin)
%SIGNAL creates a vector of length N representing a pre-specified signal

if nargin < 2
    error('Not enough arguments: must specify time vector and type of signal')
end

if size(t,2) > 1
    t = t.';
end

switch sig_name
case 'lin_chirp'
    h = s_lchirp(t,varargin{:});
case 'hyp_chirp'
    h = s_hchirp(t,varargin{:});
case 'gauss_noise'
    h = s_gnoise(t,varargin{:});
otherwise
    error(['unknown signal type: ',sig_name])
end

end


function h = s_lchirp(t, start, finish, phase)
    error(nargchk(3,4,nargin))
    if nargin==3
        phase = 0;
    end
    A = [2*t(1), 1;2*t(end), 1];
    c = A\[2*pi*start;2*pi*finish];
    h = cos(c(1)*t.^2 + c(2)*t + phase);
end

function h = s_hchirp(t, a, b)
    error(nargchk(3,3,nargin))
    h = cos(a./(b-t));
end

function h = s_gnoise(t, sigma)
    error(nargchk(2,2,nargin))
    h = sigma * randn(size(t));
end

    
