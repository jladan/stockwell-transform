function [e,eh,ev] = sobel(i)
%SOBEL edge detector (with periodic BCs)

% The sobel operator is defined as a convolution with
% [ -1 0 1 ]
% [ -2 0 2 ]
% [ -1 0 1 ]

% Horizontal edges
eh = circshift(i, [0,1]) - circshift(i, [0,-1]);
eh = 2*eh + circshift(i, [1,1]) - circshift(i, [1,-1]);
eh = eh  + circshift(i, [-1,1]) - circshift(i, [-1,-1]);

% Vertical edges
ev = circshift(i, [1,0]) - circshift(i, [-1,0]);
ev = 2*ev + circshift(i, [1,1]) - circshift(i, [-1,1]);
ev = ev  + circshift(i, [1,-1]) - circshift(i, [-1,-1]);

e = abs(eh) + abs(ev);
