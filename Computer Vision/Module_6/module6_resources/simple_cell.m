function simple = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi)

    % gabor_size = 25, lambda = 14, theta = 0, sigma = 11, gamma = 0.3, psi = 0

    % This is the reference implementation
    mag = (gabor_size-1)/2;
    
    % use NaN for a sanity check (in case something didn't get initialized)
    simple = nan(gabor_size, gabor_size);
    
    % get x and y from a lookup table
    mags = -mag:mag;
    
    % iterate over rows and columns of the matrix
    for jj = 1:gabor_size
        for ii = 1:gabor_size

            y = mags(jj);
            x = mags(ii);
            x_ = x*cos(theta) + y*sin(theta);
            y_ = -x*sin(theta) + y*cos(theta);
            simple(jj,ii) = exp(- (x_^2 + gamma^2*y_^2) / (2*sigma^2)) * cos(2*pi*x_/lambda + psi);
        end
    end

    % Now we make sure that this Gabor filter has zero mean, and one norm
    % You can leave this part unchanged
    simple = simple - mean(simple(:));
    simple = simple / sqrt(sum(simple(:).^2));
end

