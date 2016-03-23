function normd = local_norm(maps, n)
    % This function takes in *maps*, a set of maps that represent the
    % output of a phase invariance complex cell and *n*, which represents
    % the size of a square local neighborhood. Each map in maps
    % corresponds to a different orientation. This function should
    % normalize each map accross all orientations within a local
    % neighborhood. A local neighborhood is all of the pixels inside of a
    % small square region in the image. In this case, the local
    % neighborhood spans all 4 orientations, meaning it encompasses all of
    % the pixels in an nxn region at the same location on all 4 orientation
    % maps. To compute the normalized value of a single pixel at location
    % (i,j) in each orientation map, you should: 
    % 1.) Center an nxn square around point (i,j) and add up all of the 
    % values that fall in this region. 
    % 2.) Do the same thing for all orientations at point (i,j) and
    % sum the results from each orientation into one final number S. 
    % 3.) Divide pixel (i,j) by S in each orientation map.
    % 
    % If *maps* is hxwxo where h is the height, w is the width, and o is
    % the number of orientations, you need to do this computation for all
    % i=1:h and all j=1:w. The easiest way to do this is using convolution,
    % but you may do it however you want. If you want to use convolution,
    % take a look at the matlab function *imfilter* and set it to filter
    % using convolution (see the options tab on the *imfilter*
    % documentation page. The filter you use should contain only 1's
    % because you want to weight everything the same way.
    %
    % Also, be careful when normalizing. In matlab, 0/0 gives you an nan,
    % so you should change all resulting nan values to 0. You can use the
    % function "isnan*, which returns 1 if its argument is nan, and 0 if
    % its argument is a number.
    % =============TYPE YOUR CODE HERE=================
    normd = imfilter( maps, ones(n,n,4), 'conv' );
            
end