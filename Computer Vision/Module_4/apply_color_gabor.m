%-------------------------------------------------------------------------------------------------------------
% Use this function to apply any kind of color Gabor filter (either single- or double-opponent) to an image
% you have loaded with: image = im2double(imread('/path/to/myImage.png'));
%
% Implemented by D.A.M. for CLPS 1520 | Assignment #2: Simple cells, complex cells and color processing in V1.
%-------------------------------------------------------------------------------------------------------------

function out = apply_color_gabor(image, color_gabor)

% Mat2cell trick
c   = mat2cell(image,       [size(image,1)],        [size(image,2)],        [1 1 1]);
f   = mat2cell(color_gabor, [size(color_gabor, 1)], [size(color_gabor, 2)], [1 1 1]);

% 2D slice-wise convolutions, in each R, G, and B channel
out = sum(cell2mat(cellfun(@imfilter, c, f, 'UniformOutput', false)), 3);

% Rectify
out = max(out, 0);