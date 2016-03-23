%-------------------------------------------------------------------------------------------------------------
% Generate filters corresponding to double-opponent cells, based on a template of a monochromatic simple cell:
%
%   do_rg_gabor = RG (excited by red-green edges)
%   do_by_gabor = BY (excited by blue-yellow edges)
%
% See details of implementation in Zhang, Bahromi and Serre (2001).
% Implemented by D.A.M. for CLPS 1520 | Assignment #2: Simple cells, complex cells and color processing in V1.
%-------------------------------------------------------------------------------------------------------------

function [do_rg_gabor, do_by_gabor] = do_cell(simple)

% Initialize the filters with zeros (speeds up the program)
do_rg_gabor = zeros([size(simple), 3]);
do_by_gabor = zeros([size(simple), 3]);

% R, G, B channel weights to build opponency channels
weights     = [1/sqrt(2), -1/sqrt(2), 0; 1/sqrt(6),1/sqrt(6),-2/sqrt(6)]';

% Extend filters in the R, G, B domain
do_rg_gabor = cat(3, simple, simple, zeros(size(simple)));
do_rg_gabor = bsxfun(@times, do_rg_gabor, permute(weights(:,1), [2 3 1]));

do_by_gabor = cat(3, simple, simple, simple);
do_by_gabor = bsxfun(@times, do_by_gabor, permute(-weights(:,2), [2 3 1]));