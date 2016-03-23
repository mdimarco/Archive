function features = extractFeatures(image, net, layer_ind)


% This function serves to output a feature vector for a given layer. You
% will want to review the MatConvNet tutorial on using pre-trained networks
% to complete this function. Hint: you will need to use the function
% *vl_simplenn.m* to run the image through the network. You then need to
% choose which layer you would like to access. You may choose to reshape
% your output within this function or in your module's code.
% ===========TYPE YOUR CODE HERE================


res = vl_simplenn(net, image);
features = reshape( res(layer_ind).x, [1, numel( res(layer_ind).x )] );


end