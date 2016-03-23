
%Mason DiMarco
%Brown id: mdimarco


%% Module 1: The LN Model
% Last updated: September 2015

%% 
% The goal of this exercise is to (re-)familiarize yourself with the
% MATLAB environment, refresh your memory with basic matlab commands, and
% begin learning a little bit about image convolution using a set of simple
% filters.
%
% The exercise is divided into different parts/cells. Each subpart starts
% with '%%'. It is usually best to navigate each one cell at a time. There will be a
% lab similar to this one each week that will implement the ideas presented
% by Prof. Serre. At the end of each week, you will upload your complete
% code to Canvas. Your final code should be fully annotated, which means
% that you are describing each step of your process with comments. You
% should read each lab fully, and look for places that say "Fill out the
% code here" -- this is where you will need to do your work.

% All necessary images and template code will be supplied in separate
% folders on Canvas. Images will be located in the folder 'resources', and
% template functions are located in the folder 'template_functions'. For
% your own organization, it will be helpful to make a folder for each
% subheading of each lab in Canvas (e.g., one for resources, one for
% template_functions, etc.).

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
%% Loading and displaying images
% An image can be represented as a matrix where each element corresponds to
% a pixel intensity value. In Matlab, we use the imread command to load and store
% an image's pixel intensities in matrix form. Give it a shot: load the
% image named 'Landscape-image.jpg' using the imread command, and save it
% as a variable called img. If you would like more information about the
% imread command, type 'help imread' into the command bar.
%
% <<landscape.jpg>>
%

% ===========TYPE YOUR CODE HERE==============
imread('resources/color_imgs/landscape.jpg');

%
% Now that you have brought the image to the workspace, try displaying the
% image. Use either the imshow , image, or the imagesc command to display the
% image on your monitor. You should also check out the help for these three
% commands and see how they differ. Add a title to your image using the
% function *title*.

% ===========TYPE YOUR CODE HERE==============
image(imread('resources/color_imgs/landscape.jpg'));
title('landscape');

%% Resizing an image
% Load boat1.jpg and boat2.jpg
%
% <<boat1.jpg>>
%
% <<boat2.jpg>>
%

% ===========TYPE YOUR CODE HERE==============
boat1 = imread('resources/color_imgs/boat1.jpg');
boat2 = imread('resources/color_imgs/boat2.jpg');

size1 = size(boat1);
size2 = size(boat2);

%%
% Let's resize boat2 so that it is the same size as boat1. Use the imresize
% command to do this. You can find the dimensions of an image using the
% size command. Notice that each boat image has a third dimension of size
% three -- these are the RGB color channels.

% ===========TYPE YOUR CODE HERE==============
boat2= imresize( boat2, size1(1:2));
%image(boat2);
%image(boat1);
imshow(boat2);
%% Arithmetic with images
% There are a few variations of types of matrices that Matlab can handle, 
% the most common being uint8, single, and double. Some built-in 
% functions work poorly with other types, such as uint8. Let's convert both
% images to double precision using the command double. 

% ===========TYPE YOUR CODE HERE==============
boat1 = im2double(boat1);
boat2 = im2double(boat2);
%%
% Grayscale images are just 2D arrays of numbers (= matrices).
% If two images are the same size, you can add them up, multiply them by a
% scalar or another image the same size. Essentially anything you would do
% to matrices. Compute boat1 + boat2 divided by two and save it as the
% variable boat3.

% ===========TYPE YOUR CODE HERE==============
boat3 = boat1/2+boat2/2;

%%
% Display boat1, boat2 and boat3

% ===========TYPE YOUR CODE HERE==============

figure(1);
imshow(boat1);

figure(2);
imshow(boat2);

figure(3);
imshow(boat3);


%%
% Convert img (the landscape image) to grayscale using the command rgb2gray
% and save it as the variable gray_img.
% Then, try to multiply gray_img by a scalar and display the result.
% Show the image, and remember to change the colormap to gray (using the
% command *colormap gray*. You should do this for all grayscale images from
% here on out.

% ===========TYPE YOUR CODE HERE==============
landscape = imread('resources/color_imgs/landscape.jpg');
figure(1);
imshow( landscape );
gray_img = rgb2gray( landscape );

colormap gray
figure(2);
imshow( gray_img*1.5 );

%%
% You can also interpolate between images, which effectively means showing
% one image on top of another, with a weight assigned to each. Take 80%
% of boat 2 and 20% of boat 1, and add them together. Display the result.

% ===========TYPE YOUR CODE HERE==============
imshow( boat1*.2+boat2*.8 );

%% Color images; color channels of an image.
% Load speelgoed.png and save it as the variable called img.
%
% <<speelgoed.png>>
%

% ===========TYPE YOUR CODE HERE==============
speel = imread('resources/color_imgs/speelgoed.png');

imshow(speel)

%%
% An RGB image has 3 color channels, which are stored in the third
% of an image's array. Below try extracting each one of
% these channels -- storing them in variables R, G and B. Display them
% along with the original image. Again, remember to change the colormap to
% gray.

% You can navigate the third dimension of the image by using colons for the
% first two dimensions. For example, to call the first layer of the third
% dimension, you would use img(:,:,1).

% ===========TYPE YOUR CODE HERE==============
r = speel(:,:,1);
g = speel(:,:,2);
b = speel(:,:,3);

colormap gray
figure(1);
imshow(r);
figure(2);
imshow(g);
figure(3);
imshow(b);
figure(4);
imshow(speel);

%%
% Color swapping: we can now re-assemble a color image by reconcatenating
% these 3 channels, possibly in a different order. Below, try a couple
% different combinations of color channel ordering. Comment on what you see
% happening.

% ===========TYPE YOUR CODE HERE==============
reverseRB = speel;
reverseRB(:,:,1) = b;
reverseRB(:,:,3) = r;

figure(1);
imshow(reverseRB);
figure(2);
imshow(speel)

%% Part 2 %%
%%%%%%%%%%%%
%% Convolution
% Now, we will play with some simple filters to get a sense of what convolution
% actually does for the purpose of visual information processing. In the
% assignments, we use convolution/filtering in image processing as a model for
% what a receptive field does at a computational level. Thus, we will use the
% two concepts: convolution/filtering and receptive fields interchangeably, and
% you may do so in your assignment as well. However, please keep in mind that
% these two concepts are not strictly the same thing, as the convolution or
% filtering is a convenient mathematical model for a biological phenomenon, the
% receptive field.

%% Box filter
% First, try implementing a 25-by-25 box filter. A box filter is simply a square matrix with 
% the same values in each entry. For the purpose of this course, we will always 
% require that the norm of the filter (square root of the sum of the squares of 
% all elements) is 1.
%
% Open the function myBox_template and fill it in with the necessary
% components to create a box filter.
%
% Describe in words what it does by testing it on the following test image,
% 'brown.png'. Use the command conv2 (see the help section), and use the
% 'valid' setting, which will help maintain normal edges.
%
% <<brown.png>>
%

% ===========TYPE YOUR CODE HERE==============
addpath('template_functions')
addpath('resource');
brown = im2double( imread('resources/brown.png') );

%The box filter creation is pretty simple, just take the
%number of elements and make an m*n matrix with 1/sqrt( height*width ) as
%its entries

%The conv2 function is, in this case, going sequentially through all 4x4
%(as specified in the box creation below) "mini matrices" within the brown
%photo, multiplying each of those with their respective elements in the
%filter, and setting the center value to the sum of that product. This is
%in a way "blurring" the image, to the point that a box filter of 25x25
%would leave almost an entirely white screen. 

%This creates some difficulties with the edges of the photo simply by how
%choosing the "mini grids" works, so it seems the 'valid' keyword remedies
%that issue by filling in values for the edges of the photo

temp = myBox_template(4,4);
con = conv2( brown , temp,  'valid');
figure(1);
imshow(con);


%% Gaussian filter
% Next, build a 25-by-25 Gaussian filter with sigma = 7. There are several ways
% to generate a Gaussian filter, including a built-in MATLAB function; however, 
% for this assignment, we want you to implement this yourself (that is, without 
% using the MATLAB function; you may use it afterwards though, to make sure your
% filter looks like MATLAB's). A suggestion would be to use discrete sampling
% methods. Recall that the general structure of a Gaussian is 
% output = (1/(2*pi*sigma^2))*exp(-((y)^2/(2*sigma^2) + (x)^2/(2*sigma^2)))

% Filter the test image from 2-a) using your Gaussian filter and
% discuss how its behavior is different from the box filter that you just used.
%
% Open the function myGaussian_template and fill it in with the necessary
% components to create a Gaussian filter.
% *Make sure the resulting file is in your MATLAB path.*
%
% *Describe in words what it does by testing it on the previous test image.*
% Again, youcan use the command conv2 to perform this convolution.

% ===========TYPE YOUR CODE HERE==============

%Note, I had to put in an extra normalizing division for my gaussian filter
%to match that of this:
%G = fspecial('gaussian', [25 25],7);
gaus = myGaussian_template(25,25,1);
%This is blurring based on a gaussian distribution function. The larger the
%dimensions of the gaussian blur the large the blur will be. A higher
%standard deviation will contribute to a more overall blur, a larger height
%of the gaussian will lead to more of a vertical blur, etc.
figure(1)
imagesc( conv2(brown, gaus, 'valid') )
title('Gaussian Blur')
colormap gray


%% Center-surround filter
% You might find the above two filters too trivial to be able to form a
% meaningful model of vision. Note that the local output of any non-trivial
% filter, be it a box filter or a Gaussian filter, depends on the values of the
% image within some local neighborhood whose extent depends on how large the
% filter is. However, what specific properties of the local neighborhood the
% computation captures depends of what filter you use, which is an important
% question to ask when analyzing receptive field profiles. Thus, what we want
% from a model of visual information processing is that after each filtering
% stage, each element somehow represents some meaningful information about
% its neighborhood, thus laying a groundwork for processing structures and
% shapes in later stages. 
%
% Now we will build the center-surround receptive fields we learned about in
% class. Center-surround receptive fields can be described as a difference of
% two Gaussians. Because of their shape, they are often called 'Mexican hat'
% filters. They are a common linear model of neurons in the LGN. However,
% filters can sometimes output negative values, whereas a neuron cannot have
% negative firing rates. Thus, create both an on-center, off-surround filter
% (also called the "ON channel") and an off-center, on-surround filter (also
% called the "OFF channel") by using half-wave rectification on the output of a
% difference of Gaussians filter. Process 'brown.png' with the new filter.
% Show the output and discuss what it signifies, and why it is important.
%
% Open the function mexicanHat_template and fill it in with the necessary
% components to create a Mexican hat filter. Recall that a Mexican Hat
% filter is simply the difference of two Gaussians, so you should include
% your already-written Gaussian function in this Mexican Hat function.
% Don't forget to normalize your filter so that the norm is 1.
%
% *Make sure the resulting file is in your MATLAB path.*
%
% *Describe in words what it does by testing it on the previous test image.*
% You can again use the conv2 function to carry out this convolution.

% ===========TYPE YOUR CODE HERE==============
brown = double( imread('resources/brown.png') );

%Here I've computed the difference between two gaussians of differeng
%sigmas for the purpose of creating a center-surround blur. This is
%effectively focusing the pixels in the image towards the areas with the
%highest gradients, which results in what appears below: highlighted edges.

sombrero = mexicanHat_template(3,3,4,9); 
sombrero_convolved =  conv2( brown, sombrero, 'valid');
sombrero_rectified = max( sombrero_convolved, 0 );
figure(2);
colormap gray
imagesc( sombrero_rectified );
title('Mexican Hat Filter');


%% Simple Cells
% We are going to use a Gabor filter as our model of a bar-detecting 
% simple cell. The reason for using Gabor filters goes beyond the bar-like 
% shape of the filter's outline (such as band-pass tuning in spatial
% frequency, but this is outside the scope of this assignment); however we 
% will limit our interest to the oriented bar detection aspect of 
% simple cells. From a neurophysiological perspective, we can imagine a 
% bar detector implemented from composed center-surround ganglion cells 
% See Hubel and Wiesel's original drawing, which is included in this
% module's resources folder under the name
% hubel-and-wiesel-simple-cells.png. It will be helpful for you to look at
% this drawing.
%
% However, in computational vision, we do not usually model biology in 
% excessive detail. If we find a computational model that gets the same 
% job done with less calculation involved, that's great! Thus, we will
% begin our modeling of simple cells directly with a *Gabor filter* and 
% forget about Mexican hat filters. In other words, the Gabor filter models
% the response of a simple cell to the part of the visual input that falls 
% within its receptive field, including intermediate stages such as 
% processing by the retina and LGN, which we won't model separately.

% Mathematically speaking a Gabor 
% filter is the product of a Gaussian and a sinusoid. We have all 
% encountered the Gaussian function for computing the normal 
% distribution in statistics, but it turns out to have many useful
% properties in signal processing theory. A sinusoid is simply a sine or 
% a cosine. Product here means, for each value in the domain, the outputs 
% of the two functions are multiplied (pointwise multiplication).

%% Creating a Gabor Filter
% Write a function: 
% *gabor = simple_cell(gabor_size, lambda, theta, sigma, gamma, psi)* 
% that returns a square-sized (of width and height gabor_size) 
% Gabor filter according to the formula given in the file
% gabor-equation.png in this module's resources folder.

%%
% We provide you with a stencil, which 
% has been included in this folder. It is called *simple_cell*. 
% You will first need to fill in the body of the simple cell stencil. Once that is done, 
% vary the following parameters and display a few outputs of the function 
% (which should be square filters) you just wrote (or use your mathematical
% intuition) to determine their roles: *lambda, theta, psi, sigma, gamma*. 
% Do not simply give their technical names; rather, describe qualitatively
% their effect on the aspect of the filter. 

% Some initial parameter values

%size of the filter we are creating (width and height) 
gabor_size = 50; 
%defines wavelength > lambda = > wavelength
lambda = 4; 
%rotates the gabor filter when changed
theta = 0; 
 %standard deviation of gaussian portion (changes concentration of the function)
sigma = 4;
%controls how circulur the elipse portion of the gaussian is
gamma = 1; 
%performs a phase shift on the cosine portion of the function, 
%essentially "moving" the sinusoidal part
psi = 0; 

gabor = simple_cell_template(gabor_size, lambda, theta, sigma, gamma, psi);
surf(gabor)
title('Gabor')
%% Creating Bar Stimuli
% Now that we can generate Gabor filters to model simple cells in V1, 
% we need a function to generate a test stimulus to investigate the tuning
% properties of those simple cells. In particular, we would like to produce
% oriented bars to make a simple computational approximation of 
% Hubel & Wiesel's experiment. 

% In this lab, we will use the function create_bar.m to create such stimuli. Open this
% function and play around with it, making sure you understand what each
% input's role is.

%% Producing a Tuning Curve
% Finally, we are going to produce a tuning curve. Conceptually speaking, 
% a tuning curve plots the response of a model cell against a varying 
% quantity in the test stimulus. In our case the varying quantity is the 
% _orientation_ of the bars parametrized by the angle of rotation. Create a
% Gabor filter with the function *simple_cell* you filled out in part *1.a.*
% using the following parameters:
%
% *gabor_size = 50, lambda = 10, theta = 0, sigma = 3, gamma = 0.3, psi =
% 0*

% ===========TYPE YOUR CODE HERE==============
gabor = simple_cell_template(50,10,0,3,.3,0);

%%
% Create several test stimuli using create_bar
% consisting of rotated bars with the angle spanning all values between 0
% and 180 degrees.


addpath('resources');
%height of the bar
h = 20; 
%width of the bar
w = 40;
%angle of rotating the bar
theta = 30;
%translates the bar
s = 0;
%size of image to put bar on
image_size = 200;
bar = create_bar( h, w, theta, s, image_size );

imagesc(bar)
title('I am a bar!');

%%
% Next, Filter/convolve those with the Gabor filter and produce
% an orientation tuning curve based on those. Please make sure to rectify 
% your simple cell's response at 0, i.e. set every negative value of the 
% outputs to 0, which you can implement by calling 
% *rectified_output = max(nonrectified_output, 0)*. 
% Show the tuning curve, as well as a few examples of test stimuli 
% side-by-side with the corresponding outputs of the model simple cell

% ===========TYPE YOUR CODE HERE==============

tuning = ones(1,15);

for x=0:18
    gabor = simple_cell_template(50, 10, 0, 3, .3,0);
    bar = create_bar( 5, 30, x*10, 0, 200 );


    output = conv2(bar, gabor, 'valid');
    rekt_output = max(output, 0);
    tuning(x+1) = sum(sum(rekt_output));
    
    subplot(1,2,1)
    imagesc(bar)
    subplot(1,2,2)
    imagesc(rekt_output)
    colormap gray
    
    pause(.3)
end

figure(3)
plot(tuning)
title('Tuning Function for best orientation')

%% Orientation Histograms
% First, we will study responses of a population of units tuned to 
% different orientations by making orientation histograms, which count
% how many units tuned to each orientation get activated by the 
% presentation of a given stimulus. Before we run any algorithm, we need a
% way to get a visual input into our program. We provide you a dataset of
% natural and man-made scenes. The dataset is in the scenes folder of the
% resources zip file coming with this assignment.
% We will also be using the function *imgs = load_and_preprocess(path)*, 
% also included in the resources zip file.
% This function takes as input a path to a directory on your computer 
% (where your dataset is located, for example) and returns a cell array 
% with matrices representing images in grayscale, rescale to the numerical
% range [0, 1]. You may use imagesc() to inspect the images and use 
% colormap(gray) to display the image in grayscale.

%% Applying Gabors
% The question we are trying to answer in this portion of the assignment is: 'what is the 
% dominant orientation at each pixel location?' Our strategy is to assess 
% the  response of Gabor filters at multiple orientations and return the 
% orientation of the Gabor filter that responds the strongest. Use 
% *load_and_preprocess* (defined above) to load all images from the scene 
% dataset into memory. 

% ===========TYPE YOUR CODE HERE==============

pics = load_and_preprocess('resources/scenes');

%%
% Now, apply the filters to each image using *apply_gabors*, a function we've
% already created for you. This function does a normalized convolution or normalized dot product 
% of the filter with the image and rectifies the output. All of this can be done with the 
% following syntax: 
% 
% *filtered_image = apply_gabors(image, filters)* 
% 
% where *image* is a 2D grayscale image, and *filters* is a cell array, 
% the collection of filters you just generated.
% The first two coordinates of output array *filtered_image* are 
% image-like, whereas the third spans orientations (or, more generally, 
% Gabor filter index). By using *max()*, display the maps for all the 
% images that show the value of the maximum response across orientations.

% ===========TYPE YOUR CODE HERE==============

%Create gabor filters
gabors = cell(1,18);
for i = 1:18
    gabors{i} = simple_cell_template(50, 10, i*10 - 10, 3, .3,0);
end

%filter all images on gabors
filtered_images = cell(1,18);
for i = 1:size(pics)
    image = pics{i};
    filtered_images{i} = apply_gabors( image, gabors );
end

%find the max tuning of each image
tuning = ones(1,14);
tuning_indices = ones(1,14);
for i = 1:14
    image = filtered_images{i};
    [best_tune,ind] = max( sum(sum(image)) );
    tuning(i) = best_tune;
    tuning_indices(i) = ind;
    colormap gray
    subplot(1,2,1)
    imagesc( pics{i} );
    subplot(1,2,2)
    imagesc( image(:,:,ind) );
    pause(1.5);
end

figure(2)
plot(tuning)


%% Using Argmax
% Now, determine the argmax over these maps, that is, return maps where
% each pixel should contain the index of the orientation of the filter 
% that responds the strongest at that location. _Hint: you should still 
% use *max()* to get the argmax._ Display the maps for all the images, 
% using the jet colormap (use *colormap(jet)* after using *imagesc()*). 

% ===========TYPE YOUR CODE HERE==============

best_images = cell(1,14);

%For each image
for ind=1:14
    
    
    image = filtered_images{ind};
    best_image = ones(255,255);
    
    %For each pixel
    for x = 1:255
        for y = 1:255
            %Use the index of the best filter to highlight the orientation
            %of the edge we are at
            [max_val,max_ind] = max( image(y,x,:) );
            best_image(y,x) = max_ind;
        end
    end
    best_images{ind} = best_image;
    
    subplot(1,2,1)
    imagesc( pics{ind} );
    subplot(1,2,2)
    imagesc( best_image );
    
    
    colormap(jet)
    pause(1.5)
end


%%
% What do you observe? Are these representations an easy way to assess 
% how similar or dissimilar two images are in terms of their distribution
% of orientations?

% I observe that through this method we can categorize orientations of
% edges by the gabor filters that are best for their respective angles.
% They can show how similar/dissimilar an image is based on what kinds of
% angles can be found in the image. Two images of forrests with similar 
% trees, for example, would probably be represented more similarly in this
% way because of the common vertical orientations they would have.

%% Making the Histogram
% To be able to see the distributions of orientations at a glance for any
% image, let's compute orientation histograms. Now that you have 
% the argmax values for one image, you can use them to create a histogram.
% To do this, you only need to count how many of your argmax values
% have value 1 (first orientation), bin them, then count how many pixels
% have value 2, bin them,  etc. Fortunately, there's a MATLAB function 
% you can use out of the box. Use *hist()* to make a histogram of 
% orientations (the number of bars or bins should be equal to the number
% of orientations) for every image; y-axes should span the same values 
% to allow for meaningful comparison (use *ylim()*).

% ===========TYPE YOUR CODE HERE==============

for i=1:14
    histogram( best_images{i} );
    ylim([0,10000]);
    pause( 0.5 );
end


%%
% Report your histograms and comment on whether each histogram summarizes 
% meaningfully each image.

% Answered both questions in Comparing Histograms section below


%% Comparing Histograms
% Compare the histograms you get across all images of the dataset. 
% Do you see any systematic differences or patterns? Comment on the 
% relevance of this approach for scene understanding.

% Well in the case of the two pictures with multiple trees (#6 and #8), we
% can see that both images have more verical edge pixels than horizontal
% edge pixels. Picture #8 has many tall barren trees, however, which
% explains why such a high percentage of it's edge pixels are vertical.
% Contrast this to picture #6 which has many leaves and a hilly region and
% other edges of various angles. A smoother image seems to have a more
% spread out histogram, whereas one with many jagged edges of similar
% orientation would have a much more concentrated histogram around the
% jagged edge orientations

%% Shape From Texture
% So far, he have used the distribution of orientations to characterize 
% each image against one another. This means, by generalization, that 
% different _regions_ of the same image or scene can be compared to each 
% other through their respective histograms. Thus, by looking at a simple
% visual property, orientation, and how its local distribution 
% (meaning this distribution or histogram is computed within a region 
% strictly smaller than the image) varies, we can extract structure
% from the image. In this question, we will study a simplified instance 
% of shape-from-texture, where information in the 2D image plane tells 
% us from a 3D visual property, namely how variation in an otherwise 
% uniform texture tells us about the 3D shape of the surface the texture
% is imprinted upon.

%% Detecting Slants in Depth
% Look at the images in the surface dataset, which are in the surfaces
% folder in this assignment's zip file.
% Explain why you perceive that these surfaces are slanted in depth 
% despite being purely 2D textures displayed on a computer screen.

% I would expect that all of these seemingly uniform dots would have the
% same curvature and size, but in the case of all but the first image, this
% is not true. Instead of interpreting this as there being many different
% shapes on the plane, my brain adjusts to what would happen if i was
% looking at these circles on a wall at an angle, giving it 3d perspective.

%% More on Surface Slants
% Load images *1.jpg*, *2.jpg* and *5.jpg* from the surface dataset. 
% It might help to put these images in their own folder to use
% with *load_and_preprocess*.
% _After_ applying the battery of Gabor filters from previous question 
% *1. a.* to each of these three images, divide each output into _vertical_
% slices that are each 25 pixels in width, and on each of the slices
% (for each image) compute a histogram of orientations (so you should 
% get several histograms per image, viz. as many as there are slices).

% ===========TYPE YOUR CODE HERE==============

pic1 = load_and_preprocess( 'resources/surfaces/1');
pic2 = load_and_preprocess( 'resources/surfaces/2');
pic5 = load_and_preprocess( 'resources/surfaces/5');

filtered_surfaces = cell(1,3);
filtered_surfaces{1} = apply_gabors( pic1{1}, gabors );
filtered_surfaces{2} = apply_gabors( pic2{1}, gabors );
filtered_surfaces{3} = apply_gabors( pic5{1}, gabors );

arg_max_images = cell(1,3);
for ind=1:3
    image = filtered_surfaces{ind};
    best_image = ones(255,255);
    %For each pixel
    for x = 1:255
        for y = 1:255
            %Use the index of the best filter to highlight the orientation
            %of the edge we are at
            [max_val,max_ind] = max( image(y,x,:) );
            best_image(y,x) = max_ind;
        end
    end
    arg_max_images{ind} = best_image;
end


surface = arg_max_images{1}; %corresponds to image 1
%surface = arg_max_images{2}; %corresponds to image 2
%surface = arg_max_images{3}; %corresponds to image 5
%25 sliver histograms
for x = 1:25:250
    histogram( surface(:,x:x+25) );
    pause(1);
end

%% Part 3 %%
%%%%%%%%%%%%
%% 1. FOR loops
% Use a for loop to do the color swap on all images in the resources/ color_imgs directory.
% The dir command returns an M-by-1 structure with  the filename of the files
% contained in the 'name' field. For example, if you save the directory as
% d, then d(1).name returns the name of the first file, where name is the
% name of your file. Filenames are organized in alphanumerical order.

% ===========TYPE YOUR CODE HERE==============
images = dir('resources/color_imgs');
for i = 3:size(images,1)
    og_image = imread(strcat('resources/color_imgs/',images(i).name));
    image = og_image;
    temp = image(:,:,1);
    image(:,:,1) = image(:,:,3);
    image(:,:,3) = temp;
    
    subplot(1,2,1);
    imagesc( og_image );
    subplot(1,2,2);
    imagesc( image);
    pause
end

%% 2. Visual Illusions related to Center-Surround processing
% One of the ways that cognitive scientists verify their models is to test them
% with visual illusions. First, tell us briefly what you see from the two images
% and what part of your perception is 'illusory'. 

% Next, use the center-surround filters to process those images and tell us
% what you see. Is the filtered output 'compatible' with your perception of
% the illusion? How? You may want to vary the size of the filter to 
% maximize the illusory phenomenon.
%
% <<mach.png>>
%
% <<cornsweet.png>>
%
% Another famous illusion that is assumed to illustrate center-surround
% processing is called the Hermann grid illusion, displayed below. First,
% inspect the image and tell us what you see. Second, process the image with the
% center-surround filter and discuss the results. Again you may need to vary the
% filter size to maximize the effect.
%
% <<hermann.png>>
%

% ===========TYPE YOUR CODE HERE==============



%% 3. Tuning Curve for Translation
% Now we are going to produce a second tuning curve, this time for 
% translation. Instead of rotating the bar as in the previous question,
% keep it the same orientation as the Gabor filter you produced for *1.c.*; 
% shift the bar's center position from -10 to 10 pixels (a negative number
% indicates a shift to the left, a positive number indicates a shift to 
% the right; this should correspond to the *x_offset* parameter of function
% *create_bar*). 

% ===========TYPE YOUR CODE HERE==============


% Next, show the tuning curve, as well as a few examples of test 
% stimuli side-by-side with the corresponding outputs of the simple cell
% model.

% ===========TYPE YOUR CODE HERE==============


%% 4. 
% Perform the same activity as you did above in the subheading 'More on 
% Surface Slants,' but this time by cutting each filtered image into 
% equally-wide _horizontal_ slices of 25 pixels in width. Display all the
% histograms in an orderly fashion (hint: *subplot()* is great to organize
% such a large number of plots). 

% ===========TYPE YOUR CODE HERE==============
