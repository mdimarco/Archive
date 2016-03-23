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


figure(1)

subplot(2,1,1)
imagesc( stimage1 )
subplot(2,1,2)
imagesc( stim_filtered )

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


figure(2)

subplot(5,2,1)
imagesc( stimage1 )
title('Stim 1')

subplot(5,2,2)
imagesc( stimage2 )
title('Stim 2')

subplot(5,2,3)
imagesc( rg_filtered_stim1 )
title('Single Opponent, RG 1')

subplot(5,2,4)
imagesc( rg_filtered_stim2 )
title('Single Opponent, RG 2')

subplot(5,2,5)
imagesc( gr_filtered_stim1 )
title('Single Opponent, GR 1')

subplot(5,2,6)
imagesc( gr_filtered_stim2 )
title('Single Opponent, GR 2')

subplot(5,2,7)
imagesc( by_filtered_stim1 )
title('Single Opponent, BY 1')

subplot(5,2,8)
imagesc( by_filtered_stim2 )
title('Single Opponent, BY 2')

subplot(5,2,9)
imagesc( yb_filtered_stim1 )
title('Single Opponent, YB 1')

subplot(5,2,10)
imagesc( yb_filtered_stim2 )
title('Single Opponent, YB 2')

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


figure(3)

subplot(3,2,1)
imagesc( stimage1 )
title('Stim 1')

subplot(3,2,2)
imagesc( stimage2 )
title('Stim 2')

subplot(3,2,3)
imagesc( do_rg_filtered_stim1 )
title('Double Opponent, RG Stim 1')

subplot(3,2,4)
imagesc( do_rg_filtered_stim2 )
title('Double Opponent, RG Stim 2')

subplot(3,2,5)
imagesc( do_by_filtered_stim1 )
title('Double Opponent, BY Stim 1')

subplot(3,2,6)
imagesc( do_by_filtered_stim2 )
title('Double Opponent, BY Stim 2')

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

plane = './cactus';
forest = './desert_noobject';

%%
% Load your data using *load_and_preprocess*. Make sure there are the same
% number of images in each category. 
%
% ============TYPE YOUR CODE HERE=================cd 
plane_images = load_and_preprocess_color( plane );
forest_images = load_and_preprocess_color( forest );
%%
% Now that you have some data to work with, you can start making your
% features for classification. We want to concatenate the features we
% created in Assignment 2 and the color features we've designed in this
% module. To make sure everyone is using the same features, we've included
% precomputed gabor features for each category. They are saved in
% *gabors_forest.mat* and *gabors_plane.mat*. They are in the same order as
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

plane_size = size(plane_images, 2);
forest_size = size(forest_images, 2);
filters = {do_rg_gabor, do_by_gabor};
num_filters = size(filters, 2);


plane_filters = cell(1, num_filters);
forest_filters = cell(1, num_filters);
%For each filter
for i=1:num_filters
    filter = filters{i};
    
    %Plane Filter
    plane_filter = cell(1, plane_size);
    for j=1:plane_size
        plane_filter{j} = apply_color_gabor( plane_images{j}, filter );
    end
    plane_filters{i} = plane_filter;
    
    %Forest Filter
    forest_filter = cell(1, forest_size);
    for j=1:forest_size
        forest_filter{j} = apply_color_gabor( forest_images{j}, filter );
    end
    forest_filters{i} = forest_filter;
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

forest_filters_resized = cell(1,num_filters);
plane_filters_resized = cell(1,num_filters);

%For each filter
for i=1:num_filters
    planes_resized = cell(1, plane_size);
    %Resize / Reshape each plane
    for j=1:plane_size
        planes_resized{j} = imresize( plane_filters{i}{j}, [new_size, new_size] );
        planes_resized{j} = reshape( planes_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    plane_filters_resized{i} = reshape( cell2mat( planes_resized), [plane_size, new_size^2] );
    
    forests_resized = cell(1, forest_size);
    %Resize / Reshape each forest
    for j=1:forest_size
        forests_resized{j} = imresize( forest_filters{i}{j}, [new_size, new_size] );
        forests_resized{j} = reshape( forests_resized{j}, [1, new_size^2] );
    end
    %Concat flattened vectors
    forest_filters_resized{i} = reshape( cell2mat( forests_resized ), [forest_size, new_size^2]);
end

plane_color_features = cell2mat( plane_filters_resized );
forest_color_features = cell2mat( forest_filters_resized );


%%
% Finally, load the gabor feature maps for each category. Concatenate those
% with the color features you just computed. Make sure you concatenate them
% in the same order in both categories.

load('gabors_plane_forest.mat'); % loads gabor feature vectors for the images
num_images = 115; %min(plane_size, forest_size);


% features_forest should be a 115 x 1400 array
% features_plane should be a 115 x 1400 array

% ============TYPE YOUR CODE HERE=================
% concatenate: for instance,
features_plane =  plane_color_features(1:num_images,:);%,gabors_plane];
features_forest = forest_color_features(1:num_images,:);%,gabors_forest];


%% Classification
% Now we will train a classifier with the features you created in the
% preparation portion. The goal is to compare the classification accuracy
% produced by gabor+DO color features versus the classification accuracy
% produced by the gabors alone in Assignment 2. The rest of the assignment
% is very similar to Assignment 2, so feel free to recycle code.

%% Organizing Your Features
% We will need to split our feature vectors into two sets: training data
% and testing data. The training data will be used to train the classifier.
% This is analogous to the learning process that the visual system
% undergoes in order to recognize scenes within a specific category. Once
% our classifier is trained, we will want to test how well it can predict
% scene categories using our testing set. We will present each of our
% testing feature vectors to the classifier and have it determine which
% category it falls under.
%
% The first step is to create a list of labels that corresponds to your
% feature maps. You should use the number 1 as a label for one category,
% and the number -1 for the other category. Like your feature vectors, you
% may keep these in separate datastructures for now.
%
% ============TYPE YOUR CODE HERE=================
labels_plane = ones(num_images,1);
labels_forest = -1*ones(num_images,1);

%% 
% Next, you will want to combine all of your feature vectors into one array
% of features. Concatenate your two feature vector lists into one list of
% feature vectors, and do the same for your labels (make sure the vectors
% still line up with the correct labels.) You might also want to do this
% with your 2 datastructures of original images so it is easy to go back
% and forth between feature vector and its corresponding image.
%
% ============TYPE YOUR CODE HERE=================
features = [features_plane; features_forest];
labels =   [labels_plane;   labels_forest];

images = cell(num_images*2,1);
images(1:num_images) = plane_images(1:num_images);
images(num_images+1:2*num_images) = forest_images(1:num_images);


%% 
% Now, shuffle your list of feature vectors, labels and images. Make sure
% that you shuffle all of these lists in the *same way*. Hint: you may want
% to use matlab's randperm() function to make a permuted list of the
% numbers 1,...,n, where n is the number of rows in your list of feature
% maps. Use these as indices to shuffle all of your data in the same way.
%
% ============TYPE YOUR CODE HERE=================
numImages = size(features, 1);
randomInd = randperm(numImages);
features = features(randomInd,:);
labels = labels(randomInd);
images = images(randomInd);


%%
% Finally, divide your feature vectors, labels and images into training and
% testing data. By the end of this portion, you should have the arrays
% training_data and testing_data, which will contain samples from your
% feature vector array, training_labels and testing_labels, which will
% contain the labels for the training and testing features, and
% training_images and testing_images, wich will contain the actual images
% that correspond to your training and testing feature vectors. Your
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
% You will use your training data selected in the previous exercise to
% train a classifier. Again, please use the Matlab function *fitcsvm* to do
% this. You should not cross-validate in this section.
%
% ============TYPE YOUR CODE HERE=================
SVMModel = fitcsvm(trainData, trainLabels);

%% Testing Your Model
% Now that we have a trained classifier, it's time to test it. The goal is
% to see how it is able to predict the labels of our testing data. To do
% this, you should use the matlab function *predict()*. 
%
%        [label, Score] = predict(SVMModel,test_data)
%
% ============TYPE YOUR CODE HERE=================
    [predictLabels, score] = predict(SVMModel, testData);

%% Visualizing Data
% Visualize the images that correspond to the feature vectors closest to
% the decision boundary. You can do this by finding the testing datapoints
% that produced the lowest scores (take the absolute values so you include
% both signs.) Then, display the images that correspond to these low
% scores. Comment on why the classifier may have had trouble classifying
% these images.
%
% ============TYPE YOUR CODE HERE=================

accuracy = eval_accuracy(testLabels, predictLabels);


avg_accuracy = accuracy;
%% Measuring Accuracy
% Now verify how well our classifier works on testing data. Compute the
% accuracy of the predicted lables you just obtained. We've provided you
% with the function *eval_accuracy()* which takes in a column vector of
% your ground truth labels, and another column vector with your predicted
% labels. Compute and report your classification accuracy.
%
% ============TYPE YOUR CODE HERE=================
[val, ind] = sort(abs(score(:,1)));
edgeImgs = testImgs(ind(1:5));

for ii = 1:5
    figure; 
    imshow(edgeImgs{ii});
    title(sprintf('nearest %i',ii));
end

% Unfortunately due to the high accuracy of module 2?s results, and the
% inclusion of other gabor filters then were developed with the DO
% filtering, it is hard to justify exactly which part of the error these
% close images come from. The nearest 1 image clearly seems to be the least
% ?plane-like? of all of the airplane images, as well as has no color for
% the color filters to work on, but other than that, it?s plausible to say
% that this model may be a bit overfit, given the 96% accuracy on a 1400
% feature dataset with only 230 samples. It?s possible also that the forest
% images may just have a sheerly greater number of edges than the airplane
% ones, which could be supported by nearest 3 (a very smooth forest image).

%% Color Blindness
%
% Color blindness can sometimes be explained by a deficit of cones in the
% retina. We want to implement and examine three types of color blindness:
% protanopia (no long cone), deuteranopia (no medium cone), tritanopia (no
% short cone), by modifying the weights in *so_cell*. You'll find further
% specifications for this task in *so_cell*.
% 
% Run simulations on the Ishihara plates (ishihara_plate_1.png and
% ishihara_plate_2.png), and report your most interesting results. Comment.
% Bear in mind that this is a very simplified model of color processing. Do
% you think it is appropriate to define single-opponent cells from their
% inputs in the computer's red, green and blue channels as we did?

% See *so_cell* for solution, this is just an example of how to test your
% weights.
%
% ============TYPE YOUR CODE HERE=================
sim_cell = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi);
[rg_gabor, gr_gabor, by_gabor, yb_gabor] = so_cell(sim_cell);

stimage1 = im2double( imread('ishihara_plate_1.png') );
stimage2 = im2double( imread('ishihara_plate_2.png') );


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


figure(2)

subplot(5,2,1)
imagesc( stimage1 )
title('Plate 1')

subplot(5,2,2)
imagesc( stimage2 )
title('Plate 2')

subplot(5,2,3)
imagesc( rg_filtered_stim1 )
title('Single Opponent, RG 1')

subplot(5,2,4)
imagesc( rg_filtered_stim2 )
title('Single Opponent, RG 2')

subplot(5,2,5)
imagesc( gr_filtered_stim1 )
title('Single Opponent, GR 1')

subplot(5,2,6)
imagesc( gr_filtered_stim2 )
title('Single Opponent, GR 2')

subplot(5,2,7)
imagesc( by_filtered_stim1 )
title('Single Opponent, BY 1')

subplot(5,2,8)
imagesc( by_filtered_stim2 )
title('Single Opponent, BY 2')

subplot(5,2,9)
imagesc( yb_filtered_stim1 )
title('Single Opponent, YB 1')

subplot(5,2,10)
imagesc( yb_filtered_stim2 )
title('Single Opponent, YB 2')


% As is supported by the plots, colorblindness will certainly have an
% impact on a human's vision when trying to discern these images. As4
% humans have different kinds of opponent filters in their eyes with colors
% aside from red/blue/green, it is an oversimplification to use what has
% been done in so_cell.m, but this does give a great visualization of the
% general idea of what it appears to be color blind. 

%Protanopes would have the greatest difficulty in discerning the second
%image (according to our simplified model), as the biggest "on" factor in
%this example is a red 74. 

%Given that there is very little Blue gradient necessary for
%discernment in this picture, it can be expected that Tritanopes would not
%have much difficulty identifying the 74
