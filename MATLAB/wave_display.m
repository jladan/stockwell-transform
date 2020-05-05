function w = wave_display(c,s,wname)

if not(exist('wname'))
    wname = 'bior4.4'
end

% Level of detail decomposition
N = size(s,1)-2;

% Size of original image is stored in last row of s
w = zeros(s(end,:));

% reconstruct from blocks
i = 0; j = 0;
tmp = appcoef2(c,s,wname,N);
[n,m] = size(tmp);
w(i+(1:n),j+(1:m)) = tmp;
i = i+n; j = j+m;
for k = N:-1:1
    tmp = detcoef2('v',c,s,k);
    [n,m]=size(tmp);

    w((1:n),j+(1:m)) = tmp;
    tmp = detcoef2('h',c,s,k);
    w(i+(1:n),(1:m)) = tmp;
    tmp = detcoef2('d',c,s,k);
    w(i+(1:n),j+(1:m)) = tmp;
    i = i+n; j = j+m;
end
    


