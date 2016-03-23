function imgs = load_and_preprocess_color(path)
% Return cell array of preprocessed images from directory 'path'
    
    addpath(path);
    files = dir(path);
    fname = struct2cell(files);
    fname = fname(1,:);
    files = files(~strncmpi(fname, '.', 1)); 
    images = cell(length(files),1);
    
    
    for ii = 1:length(files)
        im = imread(files(ii).name);
        im = im2double(im);
        if size(im,3) == 1
            im = repmat(im, [1 1 3]);
        end
        im = imresize(im,[256,256],'colormap','original');
        imgs{ii} = im;
    end

end