t = -256:255;

fig = figure;

for k = logspace(0.9,2.4,100)
    h = cos(2*pi*t/k);
    w = wdost(h);
    s = fdost(h).';
    f = fftshift(fft(h).');
    figure(fig)
    plot([abs(w),abs(s),abs(f)])
    delineate_bands(512,'color','black', 'linestyle',':');
    axis([206,306,0,256])
    waitforbuttonpress;
end

