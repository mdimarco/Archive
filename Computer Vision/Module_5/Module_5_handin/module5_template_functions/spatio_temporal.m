function simple = spatio_temporal(gabor_size, omega, lambda, theta, sigma, gamma, psi)

    

    mag = (gabor_size-1)/2;
    
    % use NaN for a sanity check (in case something didn't get initialized)
    simple = nan(gabor_size, gabor_size, gabor_size);
    
    % get x and y from a lookup table
    mags = -mag:mag;
    % iterate over rows and columns of the matrix
    % ===========TYPE YOUR CODE HERE================
    
    %Rows
    for i=1:gabor_size
        y = mags(i);
        %Cols
        for j=1:gabor_size
            x = mags(j);
            %Times
            for t=1:gabor_size
                x_prime = x*cos(theta) + y*sin(theta);
                y_prime = -x*sin(theta) + y*cos(theta);
                %Gaussian Part
                gaus = exp( -1 * (x_prime.^2+gamma.^2*y_prime.^2) ./ (2*sigma.^2) );
                %Sinusoidal Part
                sinu = cos( 2*pi*x_prime./lambda + 2*pi*t./omega + psi );
                simple(i,j,t) = gaus*sinu;
            end
        end
    end
            

    % Now we make sure that this Gabor filter has zero mean, and one norm
    % You can leave this part unchanged
    simple = simple - mean(simple(:));
    simple = simple / sqrt(sum(simple(:).^2));
end

