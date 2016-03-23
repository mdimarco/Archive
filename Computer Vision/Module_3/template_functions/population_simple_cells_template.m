function maps = population_simple_cells(image)

    % You should use your *simple_cell* function to make 8  filters total: 
    % 2 filters for 4 orientations between 0 and pi. For each 
    % orientation, one filter should have psi = 0 and the other should have
    % psi = pi/2. We have provided all other parameters for you. Hint: 
    % when creating your filters, it will be easiest to put them into a 4 x
    % 2 cell array where the first dimension is orientation and the second
    % is phase; however, to use *apply_gabors*, you will have to reshape
    % this into a 1x8 cell array. To do this, simply use the builtin *reshape*
    % function. 
    
    gabor_size = 7;  
    lambda = 10;       
    sigma = 2;        
    gamma = 0.5;
    thetas = [0, pi/4, 3*pi/4, pi];
    psis = [0, pi/2];
    %Make your filters here. The output should be a 1x8 cell array. Don't
    %forget to add in the appropriate values for theta and phi.
    %==============TYPE YOUR CODE HERE==================%
    filters = cell(4,2);
    for x = 1:4
        for y = 1:2
            theta = thetas(x);
            psi = psis(y);
            filters{x,y} = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi);
        end
    end 

    
    % Again, it will be easier for you to work with 
    % this data later if you reshape this output to have dimensions: 
    % height x width x orientations x phases (HxWx4x2)
    % but you don't have to. Do whatever you feel most comfortable doing. 
    % Either way, make sure you know which filters correspond to 
    % each orientation/psi. DO NOT RECTIFY RESPONSES. 
    % ===============TYPE YOUR CODE HERE==================%
    maps = apply_gabors(image, reshape(filters,[1,8]) );
    height = size(maps, 1);
    width = size(maps, 2);
    maps = reshape(maps,[height, width, 4, 2]);
end