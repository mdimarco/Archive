function simple = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi)

% initialize your simple cell to be the desired gabor_size. mags will be
% the indices of the filter that you will loop over while creating your
% gabor filter below.

mag = (gabor_size-1)/2;
simple = nan(gabor_size,gabor_size);
mags = -mag:mag;

% TODO: Use formula for Gabor Filter to generate a matrix that
% represents a complex cell.

% -------- Write code below this line --------

for row = mags
    for col = mags
        %actual x,y
        x = col;
        y = row;
        %x' y'
        x_prime = x*cos(theta) + y*sin(theta);
        y_prime = -x*sin(theta) + y*cos(theta);
        %gaus half
        gaus = exp(- ((x_prime^2+gamma^2*y_prime^2) /(2*sigma^2)) ) ;
        %sine half
        sinusoid = cos(2*pi*x_prime/lambda + psi);
        simple( row+mag+1, col+mag+1 ) = gaus*sinusoid;
    end
end

% -------- Write code above this line --------

% Now we make sure that this Gabor filter has zero mean, and one norm
% You can leave this part unchanged

simple = simple - mean(simple(:));
simple = simple / sqrt(sum(simple(:).^2));

end