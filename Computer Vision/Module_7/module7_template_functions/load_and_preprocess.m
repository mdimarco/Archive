function imgs = load_and_preprocess(path, net)
% Return cell array of preprocessed images from directory 'path'
    %net = load('imagenet-vgg-verydeep-16.mat');

    files = dir(path);
    files = files(3:end); % truncate '.' and '..'
    n_files = length(files);
    imgs = cell(n_files,1);
    % ===========TYPE YOUR CODE HERE================

    for i=1:n_files
        im = imread(strcat(path,files(i).name)) ;
        im_ = single(im) ; % note: 0-255 range
        im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
        im_ = im_ - net.normalization.averageImage ;
        imgs{i} = im_;
    end
    
    
end