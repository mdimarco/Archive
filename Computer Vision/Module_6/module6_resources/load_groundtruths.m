function imgs = load_groundtruths(path)

    files = dir(path);
    files = files(3:end); % truncate '.' and '..'
    n_files = length(files);
    imgs = cell(n_files,1);
    
    for ii = 1:n_files
        
        im = read_pfm([path '/' files(ii).name],0);
        im = im2double(im);
        im = imresize(im, .25);
        imgs{ii} = im;
        
    end

end