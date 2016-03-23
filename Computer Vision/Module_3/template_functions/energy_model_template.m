function output = energy_model(maps)
    % This function combines the responses of two different simple cells
    % tuned to the same orientation different phases. It outputs the
    % response of a phase-invariant complex cell for each orientation. In
    % this case, it should output 4 maps, one for each rotational orientation. First,
    % make sure you know which matrices in the maps parameter correspond to
    % which orientation as psi. Next, preform the following operations for
    % each pair of maps in each orientation:
    %
    % 1.) Pointwise square the response of each of your simple cell outputs
    %     from the gabor with psi = 0 and psi = pi/2. 
    % 2.) Add the squared
    %     outputs. 
    % 3.) Take the pointwise square root of the resulting matrix. Return 
    %     the result as output.
    %
    % MAKE SURE YOU ARE NOT RECTIFYING YOUR GABOR RESPONSES. This will
    % corrupt the output of this function.
    
    % ============TYPE YOUR CODE HERE============
    
    output = sqrt( maps(:,:,:,1).^2 + maps(:,:,:,2).^2 );


end