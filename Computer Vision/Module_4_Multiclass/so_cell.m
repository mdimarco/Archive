%-------------------------------------------------------------------------------------------------------------
% Generate filters corresponding to single-opponent cells, based on a template of a monochromatic simple cell:
%
%   rg_gabor = R+G- (excited by a red center, inhibited by green surround)
%   gr_gabor = G+R- (excited by a green center, inhibited by red surround)
%   by_gabor = B+Y- (excited by a blue center, inhibited by yellow surround)
%   yb_gabor = Y+B- (excited by a yellow center, inhibited by blue surround)
%
% See details of implementation in Zhang, Bahromi and Serre (2001).
% Implemented by D.A.M. for CLPS 1520 | Assignment #4: Color Processing
%-------------------------------------------------------------------------------------------------------------

function [rg_gabor, gr_gabor, by_gabor, yb_gabor] = so_cell(simple)

% Initialize the filters with zeros (speeds up the program)
rg_gabor        = zeros([size(simple), 3]);
gr_gabor        = zeros([size(simple), 3]);
by_gabor        = zeros([size(simple), 3]);
yb_gabor        = zeros([size(simple), 3]);

% Take the positive and negative parts of the simple cell to take as center and surround, respectively
simple_positive = max(simple, 0);
simple_negative = -min(simple, 0);

% R, G, B channel weights to build opponency channels
%----------------------------------------------------

% Normal weights (normal color vision)
weights         = [1/sqrt(2), -1/sqrt(2), 0; 1/sqrt(6), 1/sqrt(6), -2/sqrt(6)]';


% Implement colorblindness weights. Hint: Just modify the second row
% (everything after the semicolon) of the normal weights. These are the
% red, green and blue channels. 

% Protanopes lack the long wavelength (a.k.a "red" -- not red as a pscyhological percept,
% but as an electromagnetic radiation)
% weights         = [0, -1/sqrt(2), 0; 0, 1/sqrt(6), -2/sqrt(6)]';

% Deuteranopes lack the medium wavelength (a.k.a "green")
%weights         = [1/sqrt(2), 0, 0; 1/sqrt(6), 0, -2/sqrt(6)]';

% Tritanopes lack the short wavelength (a.k.a "blue")
% weights         = [1/sqrt(2), -1/sqrt(2), 0; 1/sqrt(6), 1/sqrt(6), 0]';

% Extend filters in the R, G, B domain
%-------------------------------------
rg_gabor        = cat(3, simple_positive, simple_negative, zeros(size(simple)));
rg_gabor        = bsxfun(@times, rg_gabor, permute(weights(:,1), [2 3 1]));

gr_gabor        = cat(3, simple_negative, simple_positive, zeros(size(simple)));
gr_gabor        = bsxfun(@times, gr_gabor, permute(-weights(:,1), [2 3 1]));

by_gabor        = cat(3, simple_negative, simple_negative, simple_positive);
by_gabor        = bsxfun(@times, by_gabor, permute(-weights(:,2), [2 3 1]));

yb_gabor        = cat(3, simple_positive, simple_positive, simple_negative);
yb_gabor        = bsxfun(@times, yb_gabor, permute(weights(:,2), [2 3 1]));