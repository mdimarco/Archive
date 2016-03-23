function filtered_img = apply_Gabors(img, filters)
% Compute Normalized correlation between any image and any filter

n_size = size(filters,1);
n_orientations = size(filters{1},3);


[himg, wimg] = size(img);
[~, ~, n_orientations, n_phases] = size(filters{1});
filtered_img = zeros(size(img,1), size(img,2), n_size, n_orientations, n_phases);

for ii = 1:n_size
    for jj = 1:n_orientations
        for kk=1:n_phases
        
        [fh,fw] = size(filters{ii}(:,:,jj,kk));
        
        res = conv2(img, filters{ii}(:,:,jj,kk), 'same');
        filtered_img(:, :, ii, jj, kk) = res;
        
        end
    end
end

