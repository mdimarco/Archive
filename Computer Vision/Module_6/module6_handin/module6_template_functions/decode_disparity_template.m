function decoded = decode_disparity(maps)
% INPUT: width x height x n_gabor_sizes x n_orientations x n_disparities
% map. 
% OUTPUT: width x height decoded disparity map
% 
% First, average maps over different gabor sizes (dimension 3) and
% orientations (dimension 4). This should result in a width x height x 1 x
% 1 x n_disparities map. You might want to use the function *permute* to
% rearrange dimensions to get a width x height x n_disparities matrix.

% ============TYPE YOUR CODE HERE===============
num_sizes = size(maps,3);
num_orient = size(maps,4);


maps = permute(maps, [1,2,5,3,4]);
% Sum over size/orient and divide by num size/orient
avg_maps = sum( sum( maps, 4), 5 ) ./ num_sizes*num_orient;
avg_maps = squeeze( avg_maps );

% Now maps is of dimension width x height x disparity



% Now, take the argmax accross disparities and return the result. You
% should only consider the pixels of the image where the maximum across
% disparities is greater than the threshold we are providing below. Thus,
% you should replace the indices in the argmax map that correspond to a
% maximum value lower than the threshold with the value 0. To do this, you
% might want to use the matlab function *find*, or use logical indexing.

threshold = 0.001;


% ============TYPE YOUR CODE HERE===============
avg_maps( avg_maps<threshold ) = 0;

[~, decoded] = max( avg_maps, [], 3);


end 