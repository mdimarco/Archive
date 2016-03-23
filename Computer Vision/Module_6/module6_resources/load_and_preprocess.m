function imgs = load_and_preprocess(path)
% Return cell array of preprocessed images from directory 'path'

    files = dir(path);
    files = files(3:end); % truncate '.' and '..'
    if length(files) > 5
        files = files(2:end);
    end

    n_files = length(files);
    imgs = cell(n_files,1);
    
    for ii = 1:n_files
        
        im = imread([path '/' files(ii).name]);
        if length(size(im)) == 3
            im = rgb2gray(im);
        end
        im = im2double(im);
        im = imresize(im, .25);
        imgs{ii} = im;
        
    end

end

