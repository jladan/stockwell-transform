function c = complex2colour(d)
%COMPLEX2COLOUR Takes a complex valued plot and colourizes a plot of the amplitude
%
%   c = complex2colour(M) creates an image c, in which the brightness of each pixel corresponds
%           to the magnitude, and the hue corresponds to the phase.
%
%   This can be used to create visualizations of complex 2D data where both aspects are important
%
%   Currently, no normalization is done.

s = .8;

c(:,:,1) = (pi+angle(d))/2/pi;
c(:,:,2) = s;
c(:,:,3) = abs(d);

c = hsv2rgb(c);
