%% load and preprocess images
function images = load_and_preprocess(path)
    addpath(path);
    files = dir(path);
    fname = struct2cell(files);
    fname = fname(1,:);
    files = files(~strncmpi(fname, '.', 1)); 
    images = cell(length(files),1);
    
    for ii = 1:length(files)
        im = imread(files(ii).name);
        im = rgb2gray(im);
        im = im2double(im);
        im = imresize(im, [256,256]);
        images{ii} = im;
    end
end