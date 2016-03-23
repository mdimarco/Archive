% maxPool.m aims to model invariance to translation in our complex cell
% model. The function takes in a 2D map and a variable pool_size, which
% determines the maximum translation (in number of pixels) that the cell 
% is invariant to. In this assignment, we begin with
% pool_size = 5, but feel free to play around with other values. Remember,
% the input image in this case should be 2-dimensional, not a 3D array of
% multiple maps.

function trans_inv_output = maxPool(img,pool_size)

   trans_inv_output = imdilate(img, ones(pool_size, pool_size));
   
end
