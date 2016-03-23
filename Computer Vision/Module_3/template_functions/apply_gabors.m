function filtered_img = apply_gabors(image, filters)
% Compute convolution image and any filter
[n_sizes, n_orientations] = size(filters);

[himg, wimg] = size(image);
[hf, wf] = size(filters{1});
size_out = max([himg - max(0, hf - 1), wimg - max(0, wf - 1)], 0);
filtered_img = zeros(size_out(1), size_out(2), n_orientations * n_sizes);

for ii = 1:n_sizes
    for jj = 1:n_orientations
        
       [fh,fw] = size(filters{ii,jj});
       assert(fh==fw);
        
       res = conv2(image, filters{ii, jj}, 'valid');
       filtered_img(:, :, jj + (ii-1)*n_orientations) = max(res, 0);

    end
end