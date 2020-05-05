% Script to do a bunch of compression tests, and retain the data
echo off

% First, the original image must be defined:

if not(exist('original_image'))
    error('original_image not defined');
end

% Next, we'll set the defaults
if not(exist('ps'))
    ps = [.2,.1,.05,.01];
end
if not(exist('wnames'))
    wnames = {'db1','db4','db15','coif4','bior2.2','bior4.4'};
end
if not(exist('measures'))
    measures = {@ssim_index,@ssim}
end

% Confirm what tests are being run
disp('Compressing to the following percentages:')
disp(['   ',num2str(ps*100)])
disp('Using the following transforms:')
disp('   1. FFT2')
disp('   2. DOST2')
for j = 1:length(wnames)
    disp(['   ',num2str(j+2),'. ',wnames{j}])
end
disp('And evaluating with the following measures:')
for j = 1:length(measures)
    disp(['   ',num2str(j),'. ',func2str(measures{j})])
end

clear m p imdata
imdata = cell(2+length(wnames),length(ps));
m = cell(2+length(wnames),length(measures));
tic;
[m(1,:),p{1},imdata(1,:)] = compression_tests(original_image,ps,@fft2,@ifft2,measures);
[m(2,:),p{2},imdata(2,:)] = compression_tests(original_image,ps,@fdost2,@ifdost2,measures);
for j = 1:length(wnames)
    [m(j+2,:),p{j+2},imdata(j+2,:)] = compression_tests_wavelet(original_image,ps,wnames{j},measures);
end

total_time = toc;
    

