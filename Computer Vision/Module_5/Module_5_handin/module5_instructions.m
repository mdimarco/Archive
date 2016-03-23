
% Mason DiMarco

%% Assignment 5: Motion and Action Recognition
% Last updated: October 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% In this module, we will try to recognize actions using motion cues from a
% dynamic visual representation. We will use a strategy similar to what we
% have used for classification in past assignments. Now, we will use 3D
% spatio-temporal filters to convolve input videos and transform all the
% videos to the new representation that could be used to classify them in
% terms of their action content. You are encouraged to recycle code that
% you wrote for your previous assignments, just make sure to submit any
% function that you use.
% 
%% Building Spatiotemporal Filters
% To prepare for the lab, you'll need to make 3D spatiotemporal filters to
% convolve with input videos. These filters will be similar to static gabor
% filters, with a few slight differences. First, these filters will have a
% time dimension. In other words, our static gabors produced by
% *simple_cell* are a function of x and y, but our spatiotemporal filters
% will be a function of x, y and t. Like *simple_cell*, your spatiotemporal
% filters will have the following parameters: 
%
%   - filter_size
%   - omega (NOTE: new parameter for wavelength along the temporal dimension)
%   - lambda
%   - theta
%   - sigma
%   - gamma
%   - psi
%
% To start, take a look at the equation given in the image 'equation.png.'
% Comment on the new parameters you see and what you suspect their roles
% will be in filtering videos.
%

%
%   The new parameters: t, omega are added 
%   into the cos in the form: 2*pi*t/omega,
%   and look like a new way of altering phase and wavelength
%   

% Next, use this equation to fill in *spatio_temporal_template.m*, which
% you can save as *spatio_temporal.m* once you've filled it in. Hint: you
% are encouraged to do this by modifying your code from *simple_cell*.
%
% ============SEE SPATIO_TEMPORAL_TEMPLATE.M=====================

%% Part 2 %%
%%%%%%%%%%%%
%% Create Filters
% Use the function you just created to create your filters. 
%
% It is important to note the significance of omega in the process of
% making spatiotemporal filters. Specifically, the sign of omega determines
% the filter's selectivity for direction of motion, i.e. a negative omega
% value detects rightward motion, and a positive omega value detects
% leftward motion. The magnitude of omega determines the filter's
% selectivity for speed of motion.
%
% We've provided some initial values below. Test different values of omega
% (both positive and negative, and of different values) to determine four
% values of omega. Find two values of omega that are selective for
% rightward motion: one for faster motion and one for slower motion. Then,
% do the same for leftward motion. Be sure to avoid aliasing effects, which
% occur by choosing a value for omega that is too small. "Aliasing" refers
% to undesirable artifacts that arise in digital filtering. A consequence
% of aliasing is that the Gabor filters do not seem to represent movement
% in a direction, instead "bouncing" from left to right.
%
% You should determine your four values of omega by visualizing the filter
% over time. Specifically, this means viewing the filter frame by frame to
% see how the filter evolves through time. Doing this should allow you to
% make an assessment of speed and direction.

addpath('module5_template_functions')
addpath('module5_resources')
gabor_size = 10; 
% slow fast right, fast slow left
omega = [-10, -5, 5, 10];     
lambda = 5;   
theta=[0, pi/2]; 
sigma = 2;    
gamma = .5;   
psi = [0,pi/2];

% ===========TYPE YOUR CODE HERE================
num_orient = size(theta,2);
num_phase = size(psi,2);
num_rate = size(omega,2);

filters = nan( gabor_size, gabor_size, gabor_size, num_orient, num_phase, num_rate);
for i=1:num_orient
    for j=1:num_phase
        for k=1:num_rate
            filter = spatio_temporal( gabor_size, omega(k), lambda, theta(i), sigma, gamma, psi(j) );
            filters( :, :, :, i, j, k ) = filter;
        end
    end
end

% The smaller value causes a faster moving filter, the negative values
% correspond to right moving filters, while the positive values correspond
% to left moving, by altering the phase of the filter within the cosine
% value when computed in spatio_temporal.m


%The smaller value moves faster

%3D filter for slow right-moving
filter1 = filters(:,:,:,1,1,1);
%3D filter for slot left-moving
filter2 = filters(:,:,:,1,1,4);

%For each timestamp for each filter
for i=1:gabor_size
    subplot(2,1,1)
    imagesc( filter1(:,:,i) )
    title('Fast - Right')
    subplot(2,1,2)
    imagesc( filter2(:,:,i) )
    title('Fast - Left')

    pause(.3)
end


%% Visualizing convolution with moving stimuli
% Now we will visualize how these Gabor filters function over time. Using
% your create_bar.m from previous assignments, create a stack of images
% (video) in which the bar moves from left to right. Some initial
% parameters are below. Visualize the video by writing a for loop that
% shows a new bar image each 0.05 second (use the *pause* command within
% your for loop).

h = 20;
w = 2;
theta_bar = 0;
s = -40:30;
img_size = 100;

% ===========TYPE YOUR CODE HERE================
num_images = size(s,2);
bars = nan(img_size,img_size,num_images);
%For each frame
for i=1:num_images
    bars(:,:,i) = create_bar(h, w, theta_bar, s(i), img_size);
    imagesc(bars(:,:,i))
    pause(.05)
end


%%
% Now, using the spatio-temporal filters you just built, convolve the bar
% video with each filter from your batch of filters. Be sure to rectify
% the output of your convolution. Do this using the convn command with the
% 'valid' flag. Visualize the output of some of the convolutions using the
% same for loop method described above. Comment on what you see.

% ===========TYPE YOUR CODE HERE================

%Applying the standard filters at fast and slow left and right
ex_conv = convn( bars, squeeze(filters(:,:,:,1,1,1)), 'valid' );

filtered_map = nan( size(ex_conv,1) , size(ex_conv,2) , size(ex_conv, 3), num_orient, num_phase, num_rate );

num_frames = size( filtered_map, 3 );

%For each orientation
for i=1:num_orient
    %For each phase
    for j=1:num_phase
        %For each rate
        for k=1:num_rate
            %Convolve the sequence of bars with a single 10x10x10 filter,
            %which is tuned to a specific orientation, phase, and rate
            filtered_map( :, :, :, i, j, k ) = max( convn( bars, squeeze(filters(:,:,:,i,j,k)), 'valid' ), 0);
        end
    end
end

%Visualize
% slow fast right, fast slow left
titles = { 'Fast Right', 'Slow Right', 'Slow Left', 'Fast Left' };


%For each bar image (or each frame of the video)
for t=1:num_frames
    %Display the first orientation, first phase filter
    %For each rate
    for i=1:num_rate
        subplot(num_rate/2,num_rate/2,i)
        imagesc( filtered_map(:,:,t, 1, 1, i) )
        title( titles{i} )
    end
    pause(.5)
end


% On top of the phase-tuned and angle-tuned abilities of the filters that
% we have explored previously, these filters have rate-tuning that makes
% them move selective to direction and speed of motion.
%
% Although its more easily observed in the center pixel response than here,
% it is evident that the right moving filters are performing better than the
% left moving ones, by how closely and strongly they are able to pick up the
% signals



%% Filter's response over time
% Using the output of your convolution above, plot the response of the
% center pixel over time for each filter (corresponding to a different
% value of omega) with a vertical orientation (corresponding to theta = 0).
% Also, comment with observations. What is the maximum response for
% different values of omega? Why is this what you would expect? Explain
% what it means for the filter to be directionally selective in the context
% of these plots.
%
% ===========TYPE YOUR CODE HERE================

centers = nan( num_rate, num_frames );
half = round( size(filtered_map, 1)/2 );

for x=1:num_rate
    for y=1:num_frames
        centers(x,y) = filtered_map(half,half,y,1,1,x);
    end
end

for i=1:num_rate
    subplot(2,2,i)
    plot( centers(i, : ) );
    title( titles{i} );
end


% This gives a great showing of the strengths these filters have. Looking
% at the scale it is evident that the right moving filters perform MUCH
% better than the left moving filters, which show theire effectiveness at
% capturing direction of motion.

%% Load and Preprocess
% For this assignment, you will need a set of video data to work with. You
% can download it here:
%
%           https://brownbox.brown.edu/download.php?hash=41d9e20c
%
% NOTE: Do not turn in these videos with the rest of your assignment.
%
% Fill in the function [videos, labels] = load_and_preprocess_videos(path).
% The function should loop over all videos in the folder motions_vids, load
% them into memory, crop each video to include only the first 25 frames,
% and transform them to grayscale. *labels* is an array which contains the
% action labels (numbered 1 through 5) of each video. labels[i] correspond
% to the class (action) of the ith video. Step by step instructions are
% included in the *load_and_preprocess_videos* template. Hint: you can open
% videos using VideoReader or mmreader, and load them using the read
% command. Look at the matlab docs for more info.
%
% =============SEE LOAD_AND_PREPROCESS_VIDEOS_TEMPLATE.M===========

%%
% Now, load the videos in the actions directory using the function you 
% just filled in. 
%
% ===========TYPE YOUR CODE HERE================

[videos,labels] = load_and_preprocess_videos_template('module5_resources/motions_vids/');


%% Filter the Videos
% Fill in the function *apply_filters_template*. The function gets a cell
% array of videos (the output of *load_and_preprocess_videos*) and an array
% of filters (the filters you wrote at the beginning of Part 2). The
% function should convolve each video with each filter. The output of
% apply_filters.m should be a 4-D array, where the first three dimensions
% correspond to the dimensions of the convolved video, and the last
% dimension corresponds to each filter being used. Remember that the
% filters are now 3 dimensional because of the temporal dimension, so the
% number of filters is stored in the 4th dimension of the output, unlike
% previous assignments. The convolution should be done using the convn
% function with the 'valid' setting.
%
% ==============FILL IN APPLY_FILTERS_TEMPLATE.M===================

%%
% Now, use *apply_filters* to filter the videos you loaded above.
%
% ===========TYPE YOUR CODE HERE================

%Converting filters to a cell array from a 6-D double
filters_cell = cell(num_orient*num_phase*num_rate,1);
ind = 1;
for x = 1:num_orient
    for y = 1:num_phase
        for z = 1:num_rate
            filters_cell{ind} = filters(:,:,:,x,y,z);
            ind = ind + 1;
        end
    end
end


filtered_videos = apply_filters_template( videos, filters_cell );


%% Creating Features
% Now we will create histograms similar to the ones we created in
% Assignment 2. For each video and each frame in each video, take the
% argmax accross the 8 filter maps (if your filtered video is MxNxTxD where
% M is height, N is width, T is time, and D is number of filters, you
% should take argmax across the fourth dimension for each timepoint. This
% will give you an MxNxT matrix with values from 1 to 8). Once you do this,
% you should make a 1 x 8 histogram from each MxNxT matrix. Finally,
% normalize the histogram by dividing by the sum of each video's histogram
% values.
%
% ===========TYPE YOUR CODE HERE================



max_videos = cell( size(filtered_videos, 1), 1);
% 
for i=1:size(filtered_videos,1)
    video = filtered_videos{i};
    video_maxed = nan( size(video,1), size(video,2), size(video,4) );
    
    
    
    for h=1:size(video,1)
        for w=1:size(video,2)
            for t=1:size(video,4)
                [val,ind] = max( video(h,w,:,t) );
                 video_maxed(h,w,t) = ind;
             end
         end
     end
     max_videos{i} = video_maxed;
end

%% Normalizing and Bucketing

videos_hist = cell(size(filtered_videos,1),1);
for x=1:size(filtered_videos,1)
    curr_hist = zeros(1,16);
    video = max_videos{x};
    for h=1:size(video,1)
        for w=1:size(video,2)
            for t=1:size(video,3)
                curr_hist( video(h,w,t) ) = curr_hist( video(h,w,t) ) + 1;
            end
        end
    end
    videos_hist{x} = curr_hist / sum(curr_hist);
end
    

%%
                
for x=10:50
    imagesc(max_videos{x}(:,:,1))
    pause(.05)
end
        

%% Classification
% You will now use these features using the same classification pipeline
% that you created in previous assignments. Feel free to recycle your code.
% The first thing you must do is select two out of the five categories to
% use for classification. Store each category in its own matrix and do the
% same with the corresponding labels. Whichever categories you choose, make
% sure each contains the same number of videos before proceeding.
%
% Note: You are only required to perform binary classification between two
% action types (of your choice), but Matlab also offers multi-class SVM
% functionality. Read more about this by reading the documentation for
% fitcecoc.It is optional, but feel free to play around with this if you
% have time and a good machine.
%
% ===========TYPE YOUR CODE HERE================


%Doing the first 2 videos
%features = videos_hist(1:100);
%labels = labels(1:100);

features = nan(100,numel(max_videos{1}));
for i=1:100
    features(i,:) = reshape(max_videos{i},1,numel(max_videos{i}));
end

    
    
%% 
% Next, you will want to combine all of your feature vectors into one array
% of features. Concatenate your two feature vector lists into one list of
% feature vectors, and do the same for your labels (make sure the vectors
% still line up with the correct labels.)
%
% ===========TYPE YOUR CODE HERE================

%features = cell2mat(features);



%% 
% Now, shuffle your list of feature vectors and labels. Make sure that you
% shuffle all of these lists in the *same way*. Hint: you may want to use
% matlab's randperm() function to make a permuted list of the numbers 1..n,
% where n is the number of rows in your list of feature maps. Use these as
% indices to shuffle all of your data in the same way.
%
% ===========TYPE YOUR CODE HERE================
randomInd = randperm(size(features,1));
features = features(randomInd,:);
labels = labels(randomInd);
%%
% Finally, divide your feature vectors and labels into training and testing
% data. By the end of this portion, you should have the arrays
% training_data and testing_data, which will contain samples from your
% feature vector array and training_labels and testing_labels, which will
% contain the labels for the training and testing features. Your
% training_data array should contain about 80% of your feature maps, and
% testing_data should contain the remaining 20%.
%
% ===========TYPE YOUR CODE HERE================
numFeatures = size(features,1);

numTrain = ceil(numFeatures * 0.80);
numTest = numFeatures - numTrain;

trainData = features(1:numTrain,:);
trainLabels = labels(1:numTrain);

testData = features(numTrain+1:numFeatures,:);
testLabels = labels(numTrain+1:numFeatures);
%%
% You will use your training data to train a linear SVM. You may copy and
% paste the code you wrote in previous assignments for this portion. You do
% not need to visualize the support vectors in this assignment.
%
% ===========TYPE YOUR CODE HERE================

%Train
SVMModel = fitcsvm(trainData, trainLabels);

%Test
[pred_labs, pred_score] = predict( SVMModel, testData );


%Acc
accs = eval_accuracy( testLabels, pred_labs );
disp(accs)

%% Experimenting with Features
% Try using the spatial features you used in Assignment 2 and see what it
% does to your accuracy score. For each frame and each video, apply
% *simple_cell* and take the argmax accross the maps from different gabor
% filters. This will give you an MxN map for each frame consisting of 1 to
% 8. Make a histogram from this final representation and repeat the
% classification process.
%
% ===========TYPE YOUR CODE HERE================



gabor_size = 10; 
lambda = [3, 5];
theta = [0,45,90,135];
sigma = 4;
gamma = 0.3;
psi = 0;
spacial_filters = cell(2,4);
for s_i = 1:2 %Lambda index
    for o_i = 1:4 %Orientation index
        spacial_filters{s_i,o_i} = simple_cell(gabor_size, lambda(s_i), theta(o_i), sigma, gamma, psi);
    end
end

% APPLYING GABORS

spatio_filtered_videos = cell( numel(videos), 1);

for v=1:numel(videos)
    %hxwxt video
    video = videos{v};
    video_size = size(video);

    %hxwxtxd each video filtered by each filter
    cropped_height = max( video_size(1) - size(spacial_filters{1},1) + 1, 0);
    cropped_width  = max( video_size(2) - size(spacial_filters{1},2) + 1, 0);
    
    spatio_filtered_video = nan( cropped_height, cropped_width, numel(spacial_filters) );
    for x=1:numel(spacial_filters)
        %hxw filter
        filter = spacial_filters{x};

        for t=1:size(video,3)
            %hxw filtered frame
            filtered_frame = conv2( video(:,:,t), filter, 'valid' );
            spatio_filtered_video(:,:,t,x) = filtered_frame;
        end
    end
    spatio_filtered_videos{v} = spatio_filtered_video;
end


%% TAKING ARGMAX

max_videos = cell( size(spatio_filtered_videos) );
% 
for i=1:size(spatio_filtered_videos,1)
    video = spatio_filtered_videos{i};
    video_maxed = nan( size(video,1), size(video,2), size(video,3) );
    
    
    
    for h=1:size(video,1)
        for w=1:size(video,2)
            for t=1:size(video,3)
                [val,ind] = max( video(h,w,t,:) );
                 video_maxed(h,w,t) = ind;
             end
         end
     end
     max_videos{i} = video_maxed;
end

%% IMPLEMENTATION OF SVM 
% 
features = nan(100,numel(max_videos{1}));
for i=1:100
    features(i,:) = reshape(max_videos{i},1,numel(max_videos{i}));
end

%features = [features spatio_temporal_features];

%RANDOMIZE
randomInd = randperm(size(features,1));
features = features(randomInd,:);
labels = labels(randomInd);


numFeatures = size(features,1);
numTrain = ceil(numFeatures * 0.80);
numTest = numFeatures - numTrain;
%TRAIN
trainData = features(1:numTrain,:);
trainLabels = labels(1:numTrain);
%TEST
testData = features(numTrain+1:numFeatures,:);
testLabels = labels(numTrain+1:numFeatures);

%Train
SVMModel = fitcsvm(trainData, trainLabels);
%Test
[pred_labs, pred_score] = predict( SVMModel, testData );
%Acc
accs = eval_accuracy( testLabels, pred_labs );
disp(accs)


%% Part 3 %%
%%%%%%%%%%%%
% Report classification accuracies for the spatiotemporal features, the 
% spatial features alone, and spatiotemporal+spatial combined. 
%
% ===========TYPE YOUR CODE HERE================


% Spatio-temporal classification: ~80-95% depending on shuffle
% Spatio classification: ~55-60% depending on shuffle
% Spatio & Spatio-Temporal (combined features): 50-60% depending on shuffle
