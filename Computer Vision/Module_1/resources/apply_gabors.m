function filtered_img = apply_gabors(img, filters)
% Compute Normalized correlation between any image and any filter

%n_filters
[n_sizes, n_orientations] = size(filters);
filtered_img = zeros(size(img, 1), size(img, 2), n_orientations*n_sizes);

% we store out output in 
[ih,iw] = size(img);

for ii = 1:n_sizes
    for jj = 1:n_orientations
        
        [fh,fw] = size(filters{ii,jj});
        assert(fh==fw);

    res = normxcorr2(filters{ii,jj}, img);
        
        % crop image
        ymin = floor((fh-1)/2 + 1);
        ymax = ymin + ih - 1;
        
        xmin = floor((fw-1)/2 + 1);
        xmax = xmin + iw - 1;
        
        % size we want n-c+1 x m-c+1
        res2 = res(ymin:ymax, xmin:xmax);
        assert(all(size(res2) == size(img)));
        
        % store in output array
        filtered_img(:, :, jj + (ii-1)*n_orientations) = abs(res2);
    end
end

