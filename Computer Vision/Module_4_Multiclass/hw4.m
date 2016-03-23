%% Module 4: Color Processing Answer Key
% Last updated: October 2015
% mdimarco
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% How to turn in assignment:
%
% Your finished assignment will consist of two parts: 1) your code and
% 2) a PDF containing the meaningful outputs of your code (image
% outputs, histograms, graphs, etc.). The PDF should also include 
% comments explaining the meaning of every output. Then, create 
% a folder titled YourName_ModuleNumber.zip that contains both of
% these items, and upload it to the appropriate 'Assignments' section
% on Canvas.
%
% Note: Part 1 is mandatory but does not need to be turned in, Part 2 is
% mandatory and must be turned in, and Part 3 is optional (extra credit).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part 1 %%
%%%%%%%%%%%%
%% Background Information
% In the past couple assignments, we've developed models for simple and
% complex cells. Now we will extend our current model to incorporate color
% processing. The computational mechanisms behind color processing are in
% many ways similar to those behind luminance processing.
% 
% First, we will implement a color receptive field called 'single-opponent'
% (SO), whose computations rely on two color opponent pairs. In biological
% vision, those opponent pairs are Red-Green and Blue-Yellow. The reason
% why R-G and B-Y, among many other possible pairs, are considered opponent
% channels can be observed through the physical underpinning of the
% experience of color.

% As many of you already know, our experience of color comes from the
% different wavelengths of the light reflected by the physical surfaces.
% The wave-particle theory of light is tangential to our purposes here, but
% instead, we are simply assuming that color, like sound, is simply an
% information defined by intensity and wavelength.

% The longest wavelength of visible light is seen as red to our eyes, and
% the shortest wavelength of visible light is seen as violet. Oddly enough,
% we are taught that red and violet are very similar colors, separated only
% by a very smooth gradient. But physcially, red in violet are at the
% opposite ends of a (linear) visible light spectrum. In other words, two
% colors that have a maximal difference in wavelength are very close
% perceptually. In fact, this is only one of many instances where our
% perception of color is somewhat unrelated to the physical properties
% behind it.

% as for the colors red and green. In terms of wavelength, they are much
% more closely located in the spectrum than red and violet, but nonetheless
% we sense a much stronger difference in color.

%% IMPORTANT INCLUDED FUNCTONS:
% For this assignment, we provide you with color processing code that works
% out-of-the-box. It works by converting a simple cell Gabor filter (which
% detects luminance) you produced previously into color-sensitive cells.
% The functions are:
%
% - *so_cell.m*: This function takes in the output of *simple_cell*. It has
%       four outputs: so_rg_gabor, so_gr_gabor, so_by_gabor and
%       so_yb_gabor. These are all Gabor filters extended in the color
%       domain and they model four single-opponent color cells in V1. They
%       respectively are:
% 
%     R+G- cells (excited by red center, inhibited by green surround)
%     G+R- cells (excited by green center, inhibited by red surround)
%     B+Y- cells (excited by blue center, inhibited by yellow surround)
%     Y+B- cells (excited by yellow center, inhibited by blue surround)
% 
% Note that these color Gabor filters are three-dimensional: the first two
% dimensions are identical to the grayscale Gabor filter "simple" (these
% can be thought of as the spatial dimensions of the filter), and the third
% dimension consists in three layers (corresponding to R, G, and B channels
% of a color image).
% 
% - *do_cell.m*: This takes the output of *simple_cell* and outputs two
%       filters: do_rg_gabor and do_by_gabor. These model double-opponent
%       color cells in V1. They respectively are
%     
%       RG cells (excited by red-green edges) BY cells (excited by
%       blue-yellow edges).
%
% All other parameters, such as the preferred orientation of the output
% filters, are inferred from those of the input filter.
% 
% - *apply_color_gabor.m*: This function takes in an image and any color
%       Gabor filter (3D) as argument and processes the image with that
%       filter. The function then returns a rectified output.
%
%% Using the Color Model
% Note: Please load all images using the following command: 
% 
%     image = im2double(imread('/path/to/myImage.png'));
% 
% According to the model we've implemented in this course so far,
% edges are defined by local changes in luminance. But there are other
% visual cues leading to edge perception. Local changes in color, as much
% as changes in luminance, are a very strong cue for edge perception.
% 
% To begin to illustrate this point, load and view the sample image
% stim1.png.
%
% ============TYPE YOUR CODE HERE=================

%stimage1 = im2double( imread('stim1.png') );
%stimage2 = im2double( imread('stim2.png') );
%imagesc( stimage1 );

%% Part 2 %%
%%%%%%%%%%%%
%%
% Now, apply a gabor filter from *simple_cell* to stim1 using
% *apply_color_gabor* and inspect the output. Be careful: the image is
% three-dimensional since it is defined over R, G, and B color channels,
% whereas the filter given by the output of simple_cell is two-dimensional.
% To perform the convolution, stack three simple_cell filters on top of
% each other to create a 3D filter. One way to do this is to use: 
%
%       cat(3,simple, simple, simple)
%
% Does the output of the convolution agree with your own perception of
% color? Report your output and briefly comment. We've provided you with
% initial parameters for *simple cell*.
stimage1 = im2double( imread('stim1.png') );
stimage2 = im2double( imread('stim2.png') );


% ============TYPE YOUR CODE HERE=================
gabor_size = 50;  
lambda = 10;       
sigma = 2;        
gamma = 0.5;           
psi = 0;
theta = 0;

stim_cell = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi);
stim_cell3D = cat(3, stim_cell, stim_cell, stim_cell);
stim_filtered = apply_color_gabor( stimage1, stim_cell3D );


% figure(1)
% 
% subplot(2,1,1)
% imagesc( stimage1 )
% subplot(2,1,2)
% imagesc( stim_filtered )

% This does not agree with my idea of color because of my eye's perception
% of hue, which the gabor filter does not detect. However, 
% interestingly enough changing lambda from 2 to 1, 
% and the size from 50 to 30 does pick out edges along the boxes
% albeit with only a .02


%%
% Even though those edges are more than evident to our naked eyes, the 
% computational model that we have implemented so far has no idea of what 
% is present in the image. This is because monochromatic receptive fields 
% (modeled by *simple_cell*) are essentially insensitive to changes in hue. 

%%
% Next, run the single-opponent model, *using so_cell* and
% *apply_color_gabor*, on the stim1.png (from the previous section) and
% stim2.png. Include all possible single-opponent color channels. Show the
% results for both stimuli and comment. 
%
% Hint: your argument to *so_cell* is the output of *simple_cell*. Remember
% that *so_cell* returns 4 outputs. To get all four outputs, use the
% following syntax: [output1, output2, output3, output4] = so_cell(arg).
%
% ============TYPE YOUR CODE HERE=================
[rg_gabor, gr_gabor, by_gabor, yb_gabor] = so_cell( stim_cell );


%Red Green
rg_filtered_stim1 = apply_color_gabor( stimage1, rg_gabor );
rg_filtered_stim2 = apply_color_gabor( stimage2, rg_gabor );

%Green Red
gr_filtered_stim1 = apply_color_gabor( stimage1, gr_gabor );
gr_filtered_stim2 = apply_color_gabor( stimage2, gr_gabor );

%Blue Yellow
by_filtered_stim1 = apply_color_gabor( stimage1, by_gabor );
by_filtered_stim2 = apply_color_gabor( stimage2, by_gabor );

%Yellow Blue
yb_filtered_stim1 = apply_color_gabor( stimage1, yb_gabor );
yb_filtered_stim2 = apply_color_gabor( stimage2, yb_gabor );


% figure(2)
% 
% subplot(5,2,1)
% imagesc( stimage1 )
% title('Stim 1')
% 
% subplot(5,2,2)
% imagesc( stimage2 )
% title('Stim 2')
% 
% subplot(5,2,3)
% imagesc( rg_filtered_stim1 )
% title('Single Opponent, RG 1')
% 
% subplot(5,2,4)
% imagesc( rg_filtered_stim2 )
% title('Single Opponent, RG 2')
% 
% subplot(5,2,5)
% imagesc( gr_filtered_stim1 )
% title('Single Opponent, GR 1')
% 
% subplot(5,2,6)
% imagesc( gr_filtered_stim2 )
% title('Single Opponent, GR 2')
% 
% subplot(5,2,7)
% imagesc( by_filtered_stim1 )
% title('Single Opponent, BY 1')
% 
% subplot(5,2,8)
% imagesc( by_filtered_stim2 )
% title('Single Opponent, BY 2')
% 
% subplot(5,2,9)
% imagesc( yb_filtered_stim1 )
% title('Single Opponent, YB 1')
% 
% subplot(5,2,10)
% imagesc( yb_filtered_stim2 )
% title('Single Opponent, YB 2')

%Commented on in writeup

% This shows a much better reading than the gabor filters were. 
% By taking into account color gradients we?re able to get a great
% classification for both of these images, the SO filters that work 
% for stimulus 1 do not work for stimulus 2, and vice versa. 

%%
% Run the double-opponent model, using *do_cell* and *apply_color_gabor*,
% on stim1 and stim2 and display the results. Include all possible
% double-opponent color channels. Show the results for each color channel
% side by side in a figure for each stimulus. Comment on the results.
%
% Remember that *do_cell* returns 2 outputs.
%
% ============TYPE YOUR CODE HERE=================
[do_rg_gabor, do_by_gabor] = do_cell( stim_cell );

do_rg_filtered_stim1 = apply_color_gabor( stimage1, do_rg_gabor);
do_rg_filtered_stim2 = apply_color_gabor( stimage2, do_rg_gabor);

do_by_filtered_stim1 = apply_color_gabor( stimage1, do_by_gabor);
do_by_filtered_stim2 = apply_color_gabor( stimage2, do_by_gabor);


% figure(3)
% 
% subplot(3,2,1)
% imagesc( stimage1 )
% title('Stim 1')
% 
% subplot(3,2,2)
% imagesc( stimage2 )
% title('Stim 2')
% 
% subplot(3,2,3)
% imagesc( do_rg_filtered_stim1 )
% title('Double Opponent, RG Stim 1')
% 
% subplot(3,2,4)
% imagesc( do_rg_filtered_stim2 )
% title('Double Opponent, RG Stim 2')
% 
% subplot(3,2,5)
% imagesc( do_by_filtered_stim1 )
% title('Double Opponent, BY Stim 1')
% 
% subplot(3,2,6)
% imagesc( do_by_filtered_stim2 )
% title('Double Opponent, BY Stim 2')

% Commented on in writeup
% Here we have an even better system for filtering these images. Using the
% DO version of filtering we are able to account for color gradients we
% were not able to prior, so that we are able to identify edges on stimulus
% 1 and stimulus 2 with the same filter. Even though both images have
% changes unique to their color channels (stimulus 1 has no difference in
% green/blue, stimulus 2 has no difference in red), our filters are able to
% pick up the differences between them, and with greater accuracy than the
% simple gabor filter tried earlier ever could.

%% Classifying With Color
% In assignment 2, you implented a pipeline for binary classification using
% simple cells with different orientations to filter your stimuli. In this
% assignment, you should replicate this process while incorporating color
% features in your feature vectors to see how it impacts classification
% accuracy.

%%
% Building Color Features
% First we will have to load our data. We'll use the same data as in module
% 2. They can be downloaded here: 
%
%       https://brownbox.brown.edu/download.php?hash=53ba031a
%
% Here are the paths to the data directories: 

cactus = './cactus';
desert_noobject = './desert_noobject';
forest_noobject = './forest_noobject';
pig = './pig';
sheep = './sheep';
cow = './cow';
chicken = './chicken';

%%
% Load your data using *load_and_preprocess*. Make sure there are the same
% number of images in each category. 
%
% ============TYPE YOUR CODE HERE=================cd 
cactus_images = load_and_preprocess_color( cactus );
desert_noobject_images = load_and_preprocess_color( desert_noobject );
forest_noobject_images = load_and_preprocess_color( forest_noobject );
pig_images = load_and_preprocess_color( pig );
sheep_images = load_and_preprocess_color( sheep );
cow_images = load_and_preprocess_color( cow );
chicken_images = load_and_preprocess_color( chicken );


%%
% Now that you have some data to work with, you can start making your
% features for classification. We want to concatenate the features we
% created in Assignment 2 and the color features we've designed in this
% module. To make sure everyone is using the same features, we've included
% precomputed gabor features for each category. They are saved in
% *gabors_desert_noobject.mat* and *gabors_cactus.mat*. They are in the same order as
% *load_and_preprocess* organizes images, so make sure you maintained this
% ordering. We're going to compute double opponent color maps for each
% image and concatenate these with the gabor features.
%
% First, filter the images in each category using *apply_color_gabor* with
% the 2 gabors from *do_cell* that you created earlier. Once again,
% remember that *do_cell* returns 2 maps. You'll want to use both of these.
% You should also be sure to write this section so that it's easy to switch
% from double opponent cells to single opponent cells.
%
% ============TYPE YOUR CODE HERE=================
%stim_cell = simple_cell(50, 10, 2, .5, 0, 0);
%[do_rg_gabor, do_by_gabor] = do_cell( stim_cell );


cactus_size = size(cactus_images, 2);
desert_noobject_size = size(desert_noobject_images, 2);
forest_noobject_size = size(forest_noobject_images, 2);
pig_size = size(pig_images, 2);
chicken_size = size(chicken_images, 2);
cow_size = size(cow_images, 2);


filters = {do_rg_gabor, do_by_gabor};
num_filters = size(filters, 2);



%Instantiate filters
cactus_filters = cell(1, num_filters);
desert_noobject_filters = cell(1, num_filters);
forest_noobject_filters = cell(1, num_filters);
pig_filters = cell(1, num_filters);
sheep_filters = cell(1, num_filters);
cow_filters = cell(1, num_filters);
chicken_filters = cell(1, num_filters);

%For each filter
for i=1:num_filters
    filter = filters{i};
    
    %cactus Filter
    cactus_filter = cell(1, cactus_size);
    for j=1:cactus_size
        cactus_filter{j} = apply_color_gabor( cactus_images{j}, filter );
    end
    cactus_filters{i} = cactus_filter;
    
    %desert_noobject Filter
    desert_noobject_filter = cell(1, desert_noobject_size);
    for j=1:desert_noobject_size
        desert_noobject_filter{j} = apply_color_gabor( desert_noobject_images{j}, filter );
    end
    desert_noobject_filters{i} = desert_noobject_filter;
    
    %forest_noobject Filter
    forest_noobject_filter = cell(1, forest_noobject_size);
    for j=1:forest_noobject_size
        forest_noobject_filter{j} = apply_color_gabor( forest_noobject_images{j}, filter );
    end
    forest_noobject_filters{i} = forest_noobject_filter;
    
    %sheep Filter
    sheep_filter = cell(1, sheep_size);
    for j=1:sheep_size
        sheep_filter{j} = apply_color_gabor( sheep_images{j}, filter );
    end
    sheep_filters{i} = sheep_filter;
    
    %pig Filter
    pig_filter = cell(1, pig_size);
    for j=1:pig_size
        pig_filter{j} = apply_color_gabor( pig_images{j}, filter );
    end
    pig_filters{i} = pig_filter;
    
     %cow Filter
    cow_filter = cell(1, cow_size);
    for j=1:cow_size
        cow_filter{j} = apply_color_gabor( cow_images{j}, filter );
    end
    cow_filters{i} = cow_filter;
    
    %chicken Filter
    chicken_filter = cell(1, chicken_size);
    for j=1:chicken_size
        chicken_filter{j} = apply_color_gabor( chicken_images{j}, filter );
    end
    chicken_filters{i} = chicken_filter;
end


%%
% Now, we'll turn our color feature maps into feature vectors to feed into
% a classifier. To save memory, resize all of your feature maps to 10x10
% by using *imresize()*. Next, for each image, reshape the feature maps
% (make them into a row vector) and concatenate each of them. Make sure you
% concatenate them in the same order for each image.
%
% ============TYPE YOUR CODE HERE=================
new_size = 10;

forest_noobject_filters_resized = cell(1,num_filters);
desert_noobject_filters_resized = cell(1,num_filters);
cactus_filters_resized = cell(1,num_filters);
pig_filters_resized = cell(1,num_filters);
sheep_filters_resized = cell(1,num_filters);
cow_filters_resized = cell(1,num_filters);
chicken_filters_resized = cell(1,num_filters);


%For each filter
for i=1:num_filters
    cactuss_resized = cell(1, cactus_size);
    %Resize / Reshape each cactus
    for j=1:cactus_size
        cactuss_resized{j} = imresize( cactus_filters{i}{j}, [new_size, new_size] );
        cactuss_resized{j} = reshape( cactuss_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    cactus_filters_resized{i} = reshape( cell2mat( cactuss_resized), [cactus_size, new_size^2] );
    
    desert_noobjects_resized = cell(1, desert_noobject_size);
    %Resize / Reshape each desert_noobject
    for j=1:desert_noobject_size
        desert_noobjects_resized{j} = imresize( desert_noobject_filters{i}{j}, [new_size, new_size] );
        desert_noobjects_resized{j} = reshape( desert_noobjects_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    desert_noobject_filters_resized{i} = reshape( cell2mat( desert_noobjects_resized ), [desert_noobject_size, new_size^2]);
    
    forest_noobjects_resized = cell(1, forest_noobject_size);
    %Resize / Reshape each forest_noobject
    for j=1:forest_noobject_size
        forest_noobjects_resized{j} = imresize( forest_noobject_filters{i}{j}, [new_size, new_size] );
        forest_noobjects_resized{j} = reshape( forest_noobjects_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    forest_noobject_filters_resized{i} = reshape( cell2mat( forest_noobjects_resized ), [forest_noobject_size, new_size^2]);
    
   
    pigs_resized = cell(1, pig_size);
    %Resize / Reshape each pig
    for j=1:pig_size
        pigs_resized{j} = imresize( pig_filters{i}{j}, [new_size, new_size] );
        pigs_resized{j} = reshape( pigs_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    pig_filters_resized{i} = reshape( cell2mat( pigs_resized ), [pig_size, new_size^2]);
    
    sheeps_resized = cell(1, sheep_size);
    %Resize / Reshape each sheep
    for j=1:sheep_size
        sheeps_resized{j} = imresize( sheep_filters{i}{j}, [new_size, new_size] );
        sheeps_resized{j} = reshape( sheeps_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    sheep_filters_resized{i} = reshape( cell2mat( sheeps_resized ), [sheep_size, new_size^2]);
    
        chickens_resized = cell(1, chicken_size);
    %Resize / Reshape each chicken
    for j=1:chicken_size
        chickens_resized{j} = imresize( chicken_filters{i}{j}, [new_size, new_size] );
        chickens_resized{j} = reshape( chickens_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    chicken_filters_resized{i} = reshape( cell2mat( chickens_resized ), [chicken_size, new_size^2]);
    
    cows_resized = cell(1, cow_size);
    %Resize / Reshape each cow
    for j=1:cow_size
        cows_resized{j} = imresize( cow_filters{i}{j}, [new_size, new_size] );
        cows_resized{j} = reshape( cows_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    cow_filters_resized{i} = reshape( cell2mat( cows_resized ), [cow_size, new_size^2]);
    
end

cactus_color_features = cell2mat( cactus_filters_resized );
desert_noobject_color_features = cell2mat( desert_noobject_filters_resized );
forest_noobject_color_features = cell2mat( forest_noobject_filters_resized );
pig_color_features = cell2mat( pig_filters_resized );
sheep_color_features = cell2mat( sheep_filters_resized );
cow_color_features = cell2mat( cow_filters_resized );
chicken_color_features = cell2mat( chicken_filters_resized );


%%
% Finally, load the gabor feature maps for each category. Concatenate those
% with the color features you just computed. Make sure you concatenate them
% in the same order in both categories.

%load('gabors_cactus_desert_noobject.mat'); % loads gabor feature vectors for the images
num_images = 115; %min(cactus_size, desert_noobject_size);


% features_desert_noobject should be a 115 x 1400 array
% features_cactus should be a 115 x 1400 array

% ============TYPE YOUR CODE HERE=================
% concatenate: for instance,
features_cactus =  cactus_color_features(1:num_images,:);
features_sheep =  sheep_color_features(1:num_images,:);
features_pig  =  pig_color_features(1:num_images,:);
features_chicken  =  chicken_color_features(1:num_images,:);
features_cow  = cow_color_features(1:num_images,:);

features_desert_noobject = desert_noobject_color_features(1:num_images,:);
features_forest_noobject = forest_noobject_color_features(1:num_images,:);


%% Organizing Features & Labels

% The first step is to create a list of labels that corresponds to your
% feature maps. You should use the number 1 as a label for one category,
% and the number -1 for the other category. Like your feature vectors, you
% may keep these in separate datastructures for now.
%
labels_cactus = ones(num_images,1);
labels_pig = 2*ones(num_images,1);
labels_sheep = 3*ones(num_images,1);
labels_desert_noobject = 4*ones(num_images,1);
labels_forest_noobject = 5*ones(num_images,1);
labels_cow = 6*ones(num_images,1);
labels_chicken = 7*ones(num_images,1);

% Combine all feature vectors into one array
features = [features_cactus; features_desert_noobject; features_forest_noobject; features_pig; features_sheep; features_cow; features_chicken ];
labels =   [labels_cactus;   labels_desert_noobject; labels_forest_noobject; labels_pig; labels_sheep; labels_cow; labels_chicken];

images = cell(num_images*5,1);
images(1:num_images) = cactus_images(1:num_images);
images(num_images+1:2*num_images) = desert_noobject_images(1:num_images);
images(2*num_images+1:3*num_images) = forest_noobject_images(1:num_images);
images(3*num_images+1:4*num_images) = pig_images(1:num_images);
images(4*num_images+1:5*num_images) = sheep_images(1:num_images);
images(5*num_images+1:6*num_images) = cow_images(1:num_images);
images(6*num_images+1:7*num_images) = chicken_images(1:num_images);

%% 
% Shuffle list of feature vectors, labels and images.
numImages = size(features, 1);
randomInd = randperm(numImages);
features = features(randomInd,:);
labels = labels(randomInd);
images = images(randomInd);


%%
% Dividing your feature vectors, labels and images into training and
%
% training_data array should contain about 80% of your feature maps, and
% testing_data should contain the remaining 20%.
%
% ============TYPE YOUR CODE HERE=================
numImages = num_images*2;

numTrain = ceil(numImages * 0.80);
numTest = numImages - numTrain;

trainData = features(1:numTrain,:);
trainLabels = labels(1:numTrain);
trainImgs = images(1:numTrain);

testData = features(numTrain+1:numImages,:);
testLabels = labels(numTrain+1:numImages);
testImgs = images(numTrain+1:numImages);


%% Training Your Classifier

%Train
SVMModel = fitcecoc(trainData, trainLabels);
%Test
[pred_labs, pred_score] = predict( SVMModel, testData );
%Acc
accs = eval_accuracy( testLabels, pred_labs );
%% Images after filtering

figure(1)
imshow( apply_color_gabor(sheep_images{1},filters{2}) )
figure(2)
imshow( apply_color_gabor(cactus_images{3},filters{1}) )
