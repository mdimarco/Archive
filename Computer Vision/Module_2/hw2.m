%% Assignment 2: Computing with V1
% Last updated: September 2015
% Mason DiMarco (mdimarco)



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
% In this assignment, we'll first create simple cell-like feature maps for 
% images that fall within one of 2 categories. We will use these feature 
% maps this assignment to perform classification. 
%
%% The SUN Database
% In order to perform classification, we need a dataset. This dataset will
% be a collection of images. A portion of these images will be used to
% train our model so it has some basis for distinguishing two categories.
% The remaining images will be used to test our model. In this module,
% we'll make use of the SUN database. The SUN database contains 908
% categories, but we're only going to use a couple. You can download the
% necessary images here:
% https://brownbox.brown.edu/download.php?hash=53ba031a.

% You should create paths to your categories like these:

airplane_path = './module2_resources/airplane_cabin';
forest_path = './module2_resources/forest';

%% Computing Features
% Now that we have our data, we need to find a good way to represent it.
% Just like in Assignment 1, we're going to use Gabor filters as models of
% simple cells. We want gabors for 4 orientations between 0 and 180
% degrees, and 3 scales. We provide you with the function *simple_cell()*
% from Assignment 1 to create your filters. Make sure the function
% *simple_cell.m* is in your working directory. You can do this by using
% the function addpath. Another option is to use the combination of
% functions addpath(genpath(pwd)), which will add all underlying folders to
% your current top-level path.

% we do this for you
fdir='./module2_functions';
if exist(fdir,'dir')==7
   addpath(genpath(fdir));
else
    fprintf(sprintf('Cannot find path to %s \n',fdir));
end

% You should put your filters in a cell array and it should have dimensions
% (number scales, number orientations). We've provided you with initial
% parameters:

gabor_size = [11, 31, 51]; 
lambda = 3;
theta = [0,45,90,135];
sigma = 4;
gamma = 0.3;
psi = 0;

% ===========TYPE YOUR CODE HERE==============
filters = cell(1,4);
for s_i = 1:3 %Size index
    for o_i = 1:4 %Orientation index
        filters{s_i,o_i} = simple_cell(gabor_size(s_i), lambda, theta(o_i), sigma, gamma, psi);
    end
end
    


%% 
% Next, let's load our data using *load_and_preprocess()* from assignment
% 1. You should make 2 calls to this function: one for each of the category
% paths above. After loading each category, make sure there are the same
% number of images in each by cutting the larger one to match the size of
% the smaller. You will want to randomly select from the larger one which
% you wish to cut.
%
% ===========TYPE YOUR CODE HERE===============
forest_imgs   = load_and_preprocess( forest_path );
airplane_imgs = load_and_preprocess( airplane_path );

min_size = min( size(airplane_imgs, 1), size(forest_imgs, 1) );
forest_imgs = datasample(forest_imgs, min_size, 'Replace', false);
airplane_imgs = datasample(airplane_imgs, min_size, 'Replace', false);


%%
% Apply your filters to each of the images you just loaded. You may do this
% with our provided function "apply_gabors()*. Just as a reminder, this
% function does a normalized convolution (normalized cross-correlation or
% normalized dot product of the filter with the image and rectifies the
% output. All of this can be done with the following syntax:
%
% *filtered_image = apply_gabors(image, filters)* 
%
% where *image* is a 2D grayscale image, and *filters* is the set of
% filters you just created. 
%
% For now, make a different feature map cell array for each category. This
% is because later we'll want to make a list of labels that correspond to
% the index of each map.
%
% ============TYPE YOUR CODE HERE==============
forest_filtered = cell(115,1);
airplane_filtered = cell(115,1);

for i = 1:115
    forest_filtered{i}   = apply_gabors( forest_imgs{i}, filters );
    airplane_filtered{i} = apply_gabors( airplane_imgs{i}, filters );
end


%%
% Now, we'll turn our feature maps into feature vectors to feed into a
% classifier. To save memory, resize all of your feature maps to 10x10 by
% using *imresize()*. Next, for each image, reshape the feature maps (make
% them into a row vector) using "reshape(map, 1, 100)" -- or more simply
% using "map(:)". Then, concatenate all the feature map vectors for each image.
% Make sure you concatenate them in the same order for each image. 
% If you are unfamiliar with the term "concatenate", it means to combine them into a single
% vector. For example, concatenating the lists [2, 3, 4] and [5, 6, 7] will
% give you [2, 3, 4, 5, 6, 7]. Do this process to each category separately.
% This reshaping process is necessary in order to input the data correctly
% into a classification algorithm in the next step.

% ============TYPE YOUR CODE HERE====================
airplane_imgs_filtered_resized = cell(115,1);
for x=1:115
    %concataneted, resized map
    new_map = zeros(12, 100); 
    for y=1:12
        map = airplane_filtered{x}(:,:,y);
        %resize
        map = imresize(map, [10, 10]);
        %concat
        new_map(y,:) = reshape(map, 1, 100);
    end
    %concat
    airplane_imgs_filtered_resized{x} = reshape(new_map, 1, 1200);
end

forest_imgs_filtered_resized = cell(115,1);
for x=1:115
    %concataneted, resized map
    new_map = zeros(12, 100); 
    for y=1:12
        map = forest_filtered{x}(:,:,y);
        %resize
        map = imresize(map, [10, 10]);
        %concat
        new_map(y,:) = reshape(map, 1, 100);
    end
    %concat
    forest_imgs_filtered_resized{x} = reshape(new_map, 1, 1200);
end

 

%% Part 2 %%
%%%%%%%%%%%%
%% Classification
% In this set of exercises, we will train a classifier with the features
% you created in the first portion of the assignment.
%% Organizing Your Features
% We will need to split our feature vectors into two sets: training data
% and testing data. The training data will be used to train the classifier.
% This process is analogous to assessing what useful information is
% contained within V1. A trained classifier will be able to recognize
% differences in images and attempt to separate a set of images into
% discrete categories (classification).
%
% Once our classifier is trained, we will want to test how well it can
% predict scene categories using our testing set. We will present each of
% our testing feature vectors to the classifier and have it determine which
% category it falls under.
%
% The first step is to create a list of labels that corresponds to your
% feature maps/images. You should use the number 1 as a label for one
% category, and the number -1 for the other category. Like your feature
% vectors, you may keep these in separate data structures for now.
% 
% ==============TYPE YOUR CODE HERE=============

%Airplane label 1, Forest label -1
airplane_labels = ones(115, 1);
forest_labels = -1*ones(115, 1);

%% 
% Next, you will want to combine all of your feature vectors into one array 
% of features. Concatenate your two feature vector lists into one list of 
% feature vectors, and do the same for your labels (make sure the vectors 
% still line up with the correct labels.) You might also want to do this 
% with your 2 datas tructures of images you generated in part 1. b. so it is 
% easy to go back and forth between a feature vector and it's corresponding 
% image. 
%
%================TYPE YOUR CODE HERE============

features = cell2mat(cat(1, airplane_imgs_filtered_resized, forest_imgs_filtered_resized));
labels   = cat(1, airplane_labels, forest_labels);
images = cat(1, airplane_imgs, forest_imgs); 

%% 
% Now, shuffle your list of feature vectors, labels and images. Make sure
% that you shuffle all of these lists in the *same way*. Hint: you may want
% to use matlab's randperm() function to make a permuted list of the
% numbers 1..n, where n is the number of rows in your list of feature maps.
% Use these as indices to shuffle all of your data in the same way.
%
% ==============TYPE YOUR CODE HERE=============
shuffled_features = ones(230, 1200);
shuffled_labels = ones(230, 1);
shuffled_images = cell(230, 1); 
shuffler = randperm(230);
for x=1:230
    rand_ind = shuffler(x);
    %each 1200 column feature vector
    shuffled_features(x,:) = features(rand_ind, :);
    shuffled_labels(x) = labels(rand_ind);
    shuffled_images{x} = images{rand_ind};
end
%%
% Finally, divide your feature vectors, labels vectors, and images into
% training and testing data. By the end of this portion, you should have
% the arrays trainData and testData, which will contain samples from your
% feature vector array, trainLabels and testLabels, which will contain the
% labels for the training and testing features, and trainImgs and testImgs,
% which will contain the actual images that correspond to your training and
% test data. Your trainData array should contain 80% of your feature maps,
% and testData should contain the remaining 20%.
%
% =============TYPE YOUR CODE HERE==============
train_features = shuffled_features(1:184, :);
train_labels = shuffled_labels(1:184);
train_imgs = shuffled_images(1:184);

test_features = shuffled_features(185:end, :);
test_labels = shuffled_labels(185:end);
test_imgs = shuffled_images(185:end);

%% Training Your Classifier
% You will use your training data selected in the previous exercise to
% train a classifier. The classifier we will use here is called a Support
% Vector Machine (SVM). The SVM will find a decision boundary that
% separates your two categories based on your training data. At test time,
% it will decide which side of the boundary each of your testing feature
% maps, which will lead to a predicted label for the scene category. To
% train the classifier, you may use the matlab funciton *fitcsvm()*. This
% function takes in a matrix of training data: each row contains a feature
% vector, with each column corresponding to a particular "feature". It also
% takes in a list of labels corresponding to each of the feature vectors,
% so that each row is a different label in string format. 

% Split your data into train/test sets a couple times, and report the
% average accuracy of the model trained on trainData, and tested on
% testData.

%=============TYPE YOUR CODE HERE==================


SVMModel = fitcsvm(train_features, train_labels, 'crossval', 'on');


%% Testing Your Model
% Now that we have a trained classifier, it's time to test it. The goal is
% to see how it is able to predict the labels of our testing data. To do
% this, you should use the matlab function *predict()*. This function takes
% in the SVMModel you created in training, and a matrix of testing data
% where each row is a different feature vector. You may call this function
% as follows: [label, Score] = predict(SVMModel.Trained{1},test_data). Make
% sure to put '.Trained{1}' after SVMModel, or the function will not work
% *label* is a column vector of the same length as your training data. It
% should contain all of the predicted labels (0's or 1's). Score is a
% signed distance (positive or negative) from the decision boundary.
% Samples with a positive score indicate one class, while samples with a
% negative score indicate the other class.
%
% You can test the accuracy of your model by using the the predict
% function: http://www.mathworks.com/help/ident/ref/predict.html. This will
% give you a vector of predicted class labels for the test set based on
% your trained SVM.
%
%==============TYPE YOUR CODE HERE==================
pred_labs = cell(10,1);
pred_score = cell(10,1);
for x = 1:10
    [pred_labs{x}, pred_score{x}] = predict( SVMModel.Trained{x}, test_features );
end



%% Measuring Accuracy
% Let's verify how well our classifier works on our testing data. Compute
% the accuracy of the predicted labels you just obtained. We've provided
% you with the function *eval_accuracy()* which takes in a column vector of
% your ground truth labels, and another column vector with your predicted
% labels. Compute and report your classification accuracy. Again, you
% should report the average classification accuracy rate across all
% classifiers of SVM cross-validation.
%
%==============TYPE YOUR CODE HERE==================
accs = zeros(10,1);
for x = 1:10
    accs(x) = eval_accuracy( test_labels, pred_labs{x} );
end
mean(accs)
%% Visualizing Data
% When using an SVM, the data points closest to the decision boundary
% represent the most difficult  instances to classify. Here, you should
% visualize the images that correspond to the feature vectors closest to
% the decision boundary of your best classifier. You can do this by finding
% the testing datapoints that produced the lowest scores (take the absolute
% values so you include both signs.) The variable Score has 2 columns: each
% with the same absolute value, but with different signs. It is only
% necessary to use the first column for this part of the module. Index into
% the first column, take the absolute value, and sort the images based on
% their respective score values. Display the images that correspond to the
% 5 lowest scores.
%
%=============TYPE YOUR CODE HERE=================

pred_score_mat = zeros(46,2);
for x=1:10
    pred_score_mat = pred_score_mat + pred_score{x};
end
pred_score_mat = pred_score_mat./10;

pred_score_mat = abs(pred_score_mat(:,1));

[ sorted_scores, inds ] = sort( pred_score_mat );
for x = 1:5
    ind = inds(x);
    image1 = test_imgs{ind};
    imshow( image1 );
    pause
end

%% Comparing classification
% In order to get a baseline for our classification accuracy, let's now see
% how well a classifier performs with simple pixel intensities as inputs.
% Ideally, our classifier should perform with a higher accuracy with simple
% cell inputs. By comparing these two classifiers, we will be able to get
% an idea of how our classifier is benefitted by the simple cell model.
%
% Start off by vectorizing each image so that each image is an nx1 vector
% where n is the total number of pixels (height*width). These will act as
% your feature vectors for inputs to your classifier.

%==============TYPE YOUR CODE HERE==================
simple_pixel_images = images;
for x=1:230
    resized_pixel_image = imresize(simple_pixel_images{x}, [10, 10]);
    simple_pixel_images{x} = reshape(resized_pixel_image, 1, 100);
end

%%
% Now re-implement the classification procedure from above, except using
% our new feature vectors (our original images). In order to make a fair
% comparison to the classification above, you should rescale your feature
% maps to be the same size as your feature maps from apply_gabors.

% Report your new classification accuracy, and comment on how it differs
% and some potential reasons why.

%==============TYPE YOUR CODE HERE==================



%After this code runs the mean accuracy is printed just like the original
%one. My guess with this is that the model for image pixel densities is
%simply not as good as that of the gabor filters. This tells much less
%about orientation and averages and more than likely creates a bit of an
%overfit based on similarities in intensities in the photos. I'd also like
%to point out that with a sample size of 230, there may be an
%overfit in general.

%I will admit however that I do believe the gabor-filtered model has an
%overfit on it, perhaps due to how jpeg's deal with edges based on
%different cameras, it is able to find a clear distinction due to that. The
%problem here of course is that there are only 230 images, which is a
%relatively small sample size for 1200 features.


%Shuffled
shuffled_features = ones(230, 100);
shuffled_labels = ones(230, 1);
shuffler = randperm(230);
for x=1:230
    rand_ind = shuffler(x);
    %each 1200 column feature vector
    shuffled_features(x,:) = simple_pixel_images{rand_ind};
    shuffled_labels(x) = labels(rand_ind);
end

%Train Stuff
train_features = shuffled_features(1:184, :);
train_labels = shuffled_labels(1:184);

%Test Stuff
test_features = shuffled_features(185:end, :);
test_labels = shuffled_labels(185:end);

%Run SVM
SVMModel = fitcsvm(train_features, train_labels, 'crossval', 'on');

%Sum Accuracy
pred_labs = cell(10,1);
pred_score = cell(10,1);
for x = 1:10
    [pred_labs{x}, pred_score{x}] = predict( SVMModel.Trained{x}, test_features );
end

%Average Accuracy
accs = zeros(10,1);
for x = 1:10
    accs(x) = eval_accuracy( test_labels, pred_labs{x} );
end
mean(accs)

%% Part 3 %%
%%%%%%%%%%%%
%% Parameter Tuning
% You may have noticed there are a lot of free parameters (ex: number of
% orientations, number of scales, all of the gabor parameters, etc.).
% Parameter tuning can dramatically improve your accuracy. Try playing with
% the parameters and see if you can beat your previous accuracy. You may
% have to use the command trainsvm for this, instead of fitcsvm.

%==============TYPE YOUR CODE HERE==================

%Ok honestly I could easily do more for loops here but my computer's
%processor is crying from this right now

% Because of how hard the parameters are on a processor, I've done them 
% individually and avoided nesting the change in them. Because of the 
% possible overfit from the beginning, I only ever really found the same
% or worse accuracies from playing around with the different variables
gabor_size = [11, 31, 51]; 
lambda = 3;
theta = [0,45,90,135];
sigma = 4;
gamma = 0.3;
psi = 0;

for sigma = 3:6
    
    %Doin the gabors
    filters = cell(1,4);
    for s_i = 1:3 %Size index
        for o_i = 1:4 %Orientation index
            filters{s_i,o_i} = simple_cell(gabor_size(s_i), lambda, theta(o_i), sigma, gamma, psi);
        end
    end
    
    forest_filtered = cell(115,1);
    airplane_filtered = cell(115,1);

    for i = 1:115
        forest_filtered{i}   = apply_gabors( forest_imgs{i}, filters );
        airplane_filtered{i} = apply_gabors( airplane_imgs{i}, filters );
    end

    airplane_imgs_filtered_resized = cell(115,1);
    for x=1:115
        %concataneted, resized map
        new_map = zeros(12, 100); 
        for y=1:12
            map = airplane_filtered{x}(:,:,y);
            %resize
            map = imresize(map, [10, 10]);
            %concat
            new_map(y,:) = reshape(map, 1, 100);
        end
        %concat
        airplane_imgs_filtered_resized{x} = reshape(new_map, 1, 1200);
    end

    forest_imgs_filtered_resized = cell(115,1);
    for x=1:115
        %concataneted, resized map
        new_map = zeros(12, 100); 
        for y=1:12
            map = forest_filtered{x}(:,:,y);
            %resize
            map = imresize(map, [10, 10]);
            %concat
            new_map(y,:) = reshape(map, 1, 100);
        end
        %concat
        forest_imgs_filtered_resized{x} = reshape(new_map, 1, 1200);
    end


    airplane_labels = ones(115, 1);
    forest_labels = -1*ones(115, 1);


    features = cell2mat(cat(1, airplane_imgs_filtered_resized, forest_imgs_filtered_resized));
    labels   = cat(1, airplane_labels, forest_labels);
    images = cat(1, airplane_imgs, forest_imgs); 


    shuffled_features = ones(230, 1200);
    shuffled_labels = ones(230, 1);
    shuffled_images = cell(230, 1);
    shuffler = randperm(230);
    for x=1:230
        rand_ind = shuffler(x);
        %each 1200 column feature vector
        shuffled_features(x,:) = features(rand_ind, :);
        shuffled_labels(x) = labels(rand_ind);
        shuffled_images{x} = images{rand_ind};
    end


    train_features = shuffled_features(1:184, :);
    train_labels = shuffled_labels(1:184);
    train_imgs = shuffled_images(1:184);

    test_features = shuffled_features(185:end, :);
    test_labels = shuffled_labels(185:end);
    test_imgs = shuffled_images(185:end);


    SVMModel = fitcsvm(train_features, train_labels, 'crossval', 'on');


    pred_labs = cell(10,1);
    pred_score = cell(10,1);
    for x = 1:10
        [pred_labs{x}, pred_score{x}] = predict( SVMModel.Trained{x}, test_features );
    end

    accs = zeros(10,1);
    for x = 1:10
        accs(x) = eval_accuracy( test_labels, pred_labs{x} );
    end
    mean(accs)


end




%%
% Furthermore, try optimizing parameters within your SVM classifier, such
% as the type of kernel, or the Cost parameter (usually just called 'C', it
% specifies how much you want to avoid misclassifying each training
% example). Read the documenation on fitcsvm
% (http://www.mathworks.com/help/stats/fitcsvm.html) in order to understand
% how to change these parameters.

%==============TYPE YOUR CODE HERE==================
