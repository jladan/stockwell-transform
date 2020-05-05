
t=[0:511];
h=cos(2*pi/32*t + t.^2/512);

gchirp1=gabor(h,10);
gchirp2=gabor(h,30);
gchirp3=gabor(h,60);
gchirp4=gabor(h,100);

gchirp1=gchirp1(1:257,:);
gchirp2=gchirp2(1:257,:);
gchirp3=gchirp3(1:257,:);
gchirp4=gchirp4(1:257,:);

figure(1)
colormap('gray')

subplot(2,2,1)
contourf(abs(gchirp1))
title('width=10')
xlabel('time')

subplot(2,2,2)
contourf(abs(gchirp2))
title('width=30')
xlabel('time')

subplot(2,2,3)
contourf(abs(gchirp3))
title('width=60')
xlabel('time')

subplot(2,2,4)
contourf(abs(gchirp4))
title('width=100')
xlabel('time')



