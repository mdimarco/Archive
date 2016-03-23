%% Module 7: Deep learning using convolutional neural networks
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
% WARNING: do not include matconvnet or imagenet-vgg-verydeep16.mat or
% module7_resources in your handin.
%
% Note: Part 1 is mandatory but does not need to be turned in, Part 2 is
% mandatory and must be turned in, and Part 3 is optional (extra credit).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resources for this assignment can be downloaded here:
%
%    https://brownbox.brown.edu/download.php?hash=0ff9fd1c
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 1 %%
%%%%%%%%%%%%
% Deep learning's popularity has been on the rise for the past few years,
% arguably most notably for its applications in object detection and
% recognition. Large companies, such as Google and Facebook, rely on deep
% learning techniques for their sites' efficiency. While 'deep learning'
% encompasses a variety of models and algorithms, we'll be focusing on a
% type called convolutional neural networks in this exercise. Specifically,
% we will be using an open-source deep learning framework called MatConvNet
% to train a CNN and perform an object recognition task.
%
% CNNs are a type of multilayer perceptron that are created by stacking
% multiple convolutional layers interspersed with nonlinear steps. One of
% the most prominent convolutional neural networks -- and the one that
% broke open the scene for CNNs' viability is known as AlexNet and can be
% read about here (http://www.cs.toronto.edu/~fritz/absps/imagenet.pdf).
%
%% Installing and compiling MatConvNet
% First, download the MatConvNet files from GitHub
% (https://github.com/vlfeat/matconvnet), and follow the online
% instructions for compiling (http://www.vlfeat.org/matconvnet/install/).
% Make sure you use their test function to ensure it's working properly on
% your machine. Once you have finished this, you're ready to start using 
% MatConvNet.
% 
% Before running any code for this assignment, you should make sure to run
% vl_setupnn so that matconvnet functions are added to your MATLAB path.
% 
% ON COMPILING MATCONVNET:
% Deep Learning techniques are a lot slower to train than conventional
% machine-learningls 
% methods, so researchers use GPUs to speed things up. For this assignment,
% you do not need to compile matconvnet to support gpu acceleration.
% 
% However, if you want to use Deep Learning for your final projects, 
% the machines in the CIT Sunlab (1st floor) are equipped with NVIDIA GTX
% 460 GPUs. However, there is a bug in
% the matconvnet code that causes vl_compilenn.m to fail to recognize the
% GTX 460. 
% 
% If you want to use the GPU + matconvnet for your final projects, 
% we will be distributing a modified version of matconvnet/matlab/vl_compilenn.m 
% that fixes this.
%
%% Becoming familiar with MatConvNet's funcitons
% MatConvNet comes with a selection of built-in functions that will help
% you train and test a network (and build one, too, if you want). Take a
% look at the function descriptions to become acquainted with the
% framework's capabilities (http://www.vlfeat.org/matconvnet/functions/).
%
%% MatConvNet tutorial
% It will be a good idea to familiarize yourself with MatConvNet's provided
% tutorial. Parts 3 and 4 are optional, but parts 1, 2, and 5 will be
% especially important to your understanding CNNs.
%
%% Part 2 %%
%%%%%%%%%%%%
%% Using a pre-trained CNN for object recognition
% Normally, in order to perform object recognition using a CNN, we would
% need to first train a network (using backpropogation, as you saw in the
% tutorial), but this generally requires massive amounts of training data.
% Training a new network from scratch for a new object recognition problem
% is something you will be able to explore for your final project if you
% choose to do so. To ease our situation, we will use a pre-trained network
% provided by MatConvNet. Specifically, we will use MatConvNet's deep CNN
% to perform object recognition on our own original dataset of images. The
% images you will need for this exercise are in the resources folder.



%%
% In this lab we will be using images collected from Baxter -- a robot
% located in our very own CIT!
% First, display some of the images to get a sense of how they differ. Why
% is it necessary to have images of the same object from different angles?
% Which objects do you think the CNN will have trouble differentiating
% between?
%
% ===========TYPE YOUR RESPONSE HERE================

figure(1)
subplot(2,2,1)
imshow(imread('module7_resources/images/airplane/autoClass6_rightunspecified_rp_206.ppm'))
subplot(2,2,2)
imshow(imread('module7_resources/images/airplane/autoClass6_rightunspecified_rp_263.ppm'))
subplot(2,2,3)
imshow(imread('module7_resources/images/airplane/autoClass6_rightunspecified_rp_264.ppm'))
subplot(2,2,4)
imshow(imread('module7_resources/images/airplane/autoClass6_rightunspecified_rp_265.ppm'))


figure(2)
subplot(2,2,1)
imshow(imread('module7_resources/images/bananaBaby/autoClass4_rightunspecified_rp_96.ppm'))
subplot(2,2,2)
imshow(imread('module7_resources/images/bananaBaby/autoClass4_rightunspecified_rp_97.ppm'))
subplot(2,2,3)
imshow(imread('module7_resources/images/bananaBaby/autoClass4_rightunspecified_rp_98.ppm'))
subplot(2,2,4)
imshow(imread('module7_resources/images/bananaBaby/autoClass4_rightunspecified_rp_99.ppm'))

figure(3)
subplot(2,2,1)
imshow(imread('module7_resources/images/bottleTop/autoClass7_rightunspecified_rp_95.ppm'))
subplot(2,2,2)
imshow(imread('module7_resources/images/bottleTop/autoClass7_rightunspecified_rp_96.ppm'))
subplot(2,2,3)
imshow(imread('module7_resources/images/bottleTop/autoClass7_rightunspecified_rp_97.ppm'))
subplot(2,2,4)
imshow(imread('module7_resources/images/bottleTop/autoClass7_rightunspecified_rp_98.ppm'))


figure(4)
subplot(2,2,1)
imshow(imread('module7_resources/images/brush/autoClass6unspecified_rp_56.ppm'))
subplot(2,2,2)
imshow(imread('module7_resources/images/brush/autoClass6unspecified_rp_57.ppm'))
subplot(2,2,3)
imshow(imread('module7_resources/images/brush/autoClass6unspecified_rp_58.ppm'))
subplot(2,2,4)
imshow(imread('module7_resources/images/brush/autoClass6unspecified_rp_55.ppm'))



figure(5)
subplot(2,2,1)
imshow(imread('module7_resources/images/clothespin/autoClass4_leftunspecified_rp_95.ppm'))
subplot(2,2,2)
imshow(imread('module7_resources/images/clothespin/autoClass4_leftunspecified_rp_96.ppm'))
subplot(2,2,3)
imshow(imread('module7_resources/images/clothespin/autoClass4_leftunspecified_rp_97.ppm'))
subplot(2,2,4)
imshow(imread('module7_resources/images/clothespin/autoClass4_leftunspecified_rp_98.ppm'))

% It's necessary to have the images at different angles becaue we want an
% angle-invariant model, so that when seeing the images live / during test
% the CNN will be able to recognize the objects at different angles.


% Potentially because they are both relatively blurry and have somewhat
% similar colors/shape, bottleTop and clothespin may be difficult to
% discern. The only other I can think of being challenging is the
% bananaBaby vs airplane, due to similar colors and both being somewhat
% elongated


net = load('imagenet-vgg-verydeep-16.mat');

%%
% Next, set up MatConvNet, and load the 16-layer network imagenet-vgg-verydeep-16 
% by following the "Quick Start" tutorial: http://www.vlfeat.org/matconvnet/quick/
% You can download* the pretrained network here: http://www.vlfeat.org/matconvnet/pretrained/

% *The pretrained network file is large (>500mb). If you are using Brown
% CS machines, it may exceed your hard disk quota. As a workaround, you can
% load the file directly from this path
% '/data/people/evjang/imagenet-vgg-verydeep-16.mat'
% If you do not intend to use Brown CS machines, ignore this.

% Display the details of the network using the function vl_simplenn_display. What are
% the different types of layers, and what does each do?
%
% ===========TYPE YOUR CODE HERE================
run  matconvnet/matlab/vl_setupnn
addpath('matconvnet/matlab')
vl_simplenn_display(net)

% The three major types used seem to be convolutions, rectifications, and
% then max poolings. Convolutions are applying various filters to the images
% like we have been doing throughout the semester, rectifications are
% formatting the responses from the previous layer to remove negative
% values, and mpool is taking the maxpool across different filters as we
% have been doing to find optimal filters for different pixels.

%%
% Now we need to preprocess the images in our dataset in order to make them
% compatible as inputs to our network. In the case of MatConvNet, this
% means resizing each image and subtracting the average pixel intensity
% from each pixel of each image. If you're unsure on how to do this, check
% the MatConvNet tutorial on how to use pretrained networks. Fill in the
% template function *load_and_preprocess_template.m* and perform the
% necessary operations on each image of each object.
%
% ===========TYPE YOUR CODE HERE================

addpath('module7_template_functions')


n_types = 5;
image_folder = {'airplane', 'bananaBaby', 'bottleTop', 'brush', 'clothespin'};
images = cell(n_types,1);

for i=1:n_types
    path = strcat('module7_resources/images/',image_folder{i},'/');
    images{i} = load_and_preprocess( path, net );
end




%%
% Now we will pass the images through the CNN to get a feature vector for
% each one, which we will then use for classification. Fill in the provided
% template function *getFeatures_template.m* to create a feature vector for
% each image. You will want to resize the output to be a 4096x1 vector. You
% will want to access the final convolutional layer of the network for this
% part of the lab.
%
% ===========FILL IN GETFEATURES_TEMPLATE.M================




%%
% Now you should pass each of your images through your filled-in function
% *getFeatures.m* in order to get a feature vector for each image.
%
% ===========TYPE YOUR CODE HERE================
run  matconvnet/matlab/vl_setupnn

features = cell(n_types,1);
for x=1:n_types
    n_imgs = numel(images{x});
    features_type = cell(n_imgs,1);
    for y=1:n_imgs
        features_type{y} = extractFeatures(images{x}{y},net, 36);
    end
    features{x} = features_type;
end
    

%%
% Once you have a feature vector for each image, you need to prepare them
% as input for an SVM classifier. Using similar techniques to what you did
% in previous homeworks, perform a multi-class SVM classification on the
% data. Use 80% for training, 20% for test, and make sure you shuffle the
% inputs. Use the Matlab function fitcecoc for multi-class SVM
% classification. Report your accuracy rate.
%
% ===========TYPE YOUR CODE HERE================

addpath('module7_resources')

% Format features for SVM
features_mat = [];
labels = [];
for i=1:n_types
    features_type = cell2mat( features{i} );
    features_mat = cat(1,features_mat,features_type);
    labels = cat(1, labels, i * ones( size(features_type,1), 1 ) );
end

acc = do_SVM(features_mat,labels);

% Accuracy between 98-100%

%% Testing different layers of the CNN
% Each layer of our CNN outputs a set of features. While the top layers are
% most often used for machine learning and pattern recognition purposes,
% any layers could theoretically be used. In this part of the exercise, we
% will test how well we can classify images using features from different
% layers of the network.

% We will test the output features of separate convolutional layer. To
% begin, which layers of our network perform convolution? Hint: you may
% want to revisit the function vl_simplenn_display.
%
% ===========TYPE YOUR RESPONSE HERE================


layers_with_conv = [ 1, 3, 6, 8, 11, 13, 15, 18, 20, 22, 25, 27, 29, 32, 34, 36];
% The layers ^ perform convolution, whereas the others are
% designated for max pooling and for 




%%
% To obtain the features from layers other than the last layer, you will
% need to edit the function getFeatures.m to call your desired layer.

% Perform a similar classification as you did above, but for every third
% convolutional layer's features. It may take some time to run your code
% for each layer, so prepare your lab work accordingly. In the end, you
% should have performed classification using five layers' features,
% in addition to the top layer's classification you performed above.
%
% ===========TYPE YOUR CODE HERE================

layers = layers_with_conv(1:3:end);
accs = ones(numel(layers));
for l = 1:numel(layers)
    
    %EXTRACTING FEATURES
    features = cell(n_types,1);
    for x=1:n_types
        n_imgs = numel(images{x});
        features_type = cell(n_imgs,1);
        for y=1:n_imgs
            features_type{y} = extractFeatures(images{x}{y},net, layers(l) );
        end
        features{x} = features_type;
    end
    
    % FORMAT FEATURES FOR SVM
    features_mat = [];
    labels = [];
    for i=1:n_types
        features_type = cell2mat( features{i} );
        features_mat = cat(1,features_mat,features_type);
        labels = cat(1, labels, i * ones( size(features_type,1), 1 ) );
    end
    
    accs(l) = do_SVM(features_mat,labels);
    disp( accs(l) )   
end

% Layer   Acc
%   1   0.7671
%   8   0.9247
%   15  0.9932
%   22  0.9932
%   29  0.9726
%   36  0.9863


%% Comparing accuracy rates
% Make a plot showing classification accuracy rates across different
% layers. Does any sort of pattern emerge?
%
% ===========TYPE YOUR CODE HERE================

plot(accs)

% The later layers certainly have higher accuracies than the earlier layers


%% Part 3 %%
%%%%%%%%%%%%
%% Compare CNN to A2 classification pipeline
% Using the steps for classification given in Assignment 2 (filtering with
% simple cells, etc.), produce a new accuracy rate and report. Remember you
% will have to slightly modify your code to account for multiclass SVM.
% Comment on differences between performance of your CNN and performance of
% your A2 scheme.


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



features = [];
for i=1:5
    image_type = images{i};
    num_imgs = numel(images{i});
    images_filtered = cell(num_imgs,1);
    for j=1:num_imgs
        images_filtered{j} = apply_gabors( images{i}{j}, filters );
        images_filtered{j} = reshape( images_filtered{j}, [1,numel(images_filtered{j})]);
    end
    
    features = cat(1, features, cell2mat(images_filtered));
end


accsAssign2 = do_SVM(features, labels);

% NOTE: I did not resize the feature vectors, but this actually performed
% pretty well ( ~76% ) when not resized; much better than when it was
% resized.
