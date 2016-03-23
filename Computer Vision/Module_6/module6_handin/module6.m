%% Assignment 7: Stereo Vision Answer Sheet
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

%% INFORMATION ON RESOURCES FOR ASSIGNMENT 7
% Resources for this assignment, including images and helper functions, can
% be downloaded here:

% https://brownbox.brown.edu/download.php?hash=53553a39

% Do not include these resources in your final submissions.

%% Part 1 %%
%%%%%%%%%%%%
%% Introduction
% In this module, we will be extending what we have done in previous
% assignments to include stereo processing. We will be reproducing some of
% the key results from the paper by Qian, 1994. Qian's model provides a
% mathematical description of how the information from the monocular
% receptive fields reacting to a stimulus from each eye can be used to form
% binocular receptive fields. Furthermore, an electrophysiology study by
% Anzai et al (1999) showed that binocular receptive fields in the primary
% visual cortex can be described in terms of linear combinations of two
% identical, but laterally displaced monocular receptive fields, followed
% by a halfway-rectification and constant power. When such units are summed
% over different phases, a binocular receptive field can then be expressed
% in terms of a complex cell model, which is called the 'binocular energy
% model'. Please examine the following mathematical description:
%
%   Energy = max((L_0+ R_0),0)^p + max((L_90 + R_90),0)^p
%          + max((L_180 + R_180),0)^p + max((L_270 + R_270),0)^p 
%
% where L_theta and R_theta are responses of monocular receptive fields,
% from the left and right eyes. Disparity is implicitly defined, so in this
% expression, L_(phase) and R_(phase) are assumed to be shifted by some
% fixed amount. Also note that the max operation is applied for half-wave
% rectification -- since neurons cannot respond with negative activity, the
% model replaces it with 0. Qian showed that this expression can be further
% simplified into:
%
%   Energy = abs((L_0+ R_0))^p + abs((L_90 + R_90))^p 
%
% The abs operation is replacing the max operation as well as the
% combination of two opposing phases. This is because opposing phase units
% (180 degrees of difference) signal the same output with opposing signs,
% summing the two half wave rectified units is equivalent to simply taking
% an absolute value of one unit without half wave rectification. In this
% module, we will use p=2. The amount of lateral shift with which the
% binocular unit is created determines the disparity tuning of the unit.
% For example, by shifting the left monocular simple cell response map by
% 10 pixels to the  and then summing it element-wise with the right
% monocular simple cell response map will yield a disparity map
% corresponding to the response of binocular simple cells that have
% cross-eyed disparity tuning of 10 pixels, which will ideally detect
% physical surfaces that are closer to the eyes than the point of fixation.
% (you can get some intuition by placing two fingers in front of your eyes
% at different depths and alternating fixations between them).

%% Generate Filterbank and Stimuli
% First, you will create binocular filters / receptive fields. Using
% *simple_cell*, build a battery of Gabors using the parameters we give you
% below. You will re-use the same filters later in the assignment. The
% Gabor_size, lambda and sigma should be matched; that is, filters with
% size Gabor_size(i) should have a lambda and a sigma of lambda(i),
% sigma(i), etc.

Gabor_size = [7,19,29,39];
theta = [0, pi/4, pi/2, 3*pi/4];
psi = [0,pi/2];
lambda = [3.5,10.3, 16.8, 24];
sigma = lambda*.8;
gamma = 1;

% ===========TYPE YOUR CODE HERE================

addpath('module6_resources/')
addpath('module6_template_functions/')

% 4x1 cell array where each cell is a matrix of size:
% gab_size x gab_size x num_orient x num_phase
filters_by_size = cell(numel(Gabor_size),1);
for i=1:numel(Gabor_size)
    filter_by_size = nan(Gabor_size(i), Gabor_size(i), size(theta,2), size(psi,2));
    for j=1:size(theta,2)
        for k=1:size(psi,2)
            filter_by_size(:,:,j,k) = simple_cell(Gabor_size(i), lambda(i), theta(j), sigma(i),gamma,psi(k));
        end
    end  
    filters_by_size{i} = filter_by_size;
end
            



%%
% Now fill in the function *binocular_cell*, which takes in your filter
% bank's response to two images (left and right image) and returns the
% response of a binocular complex cell. It also takes in a range of
% disparities and an exponent p. See the template code for further
% specifications.

% ===============SEE BINOCULAR_CELL_TEMPLATE.M=============================

%% Part 2 %%
%%%%%%%%%%%%
% We give you a toy stimulus below consisting of two bars. Display the toy
% stimulus. What is its correct disparity? How do you know this?

stim_size = 500;
stim_left = zeros(stim_size/5, stim_size);
bar_width = 4;
strong_bar_pos = 300;
weak_bar_pos = 200;

stim_left(:, strong_bar_pos:(strong_bar_pos+bar_width)) = 1;
stim_left(:, weak_bar_pos:(weak_bar_pos+bar_width)) = 0.5;
stim_right = stim_left;

% ===========TYPE YOUR CODE HERE================
colormap gray
imagesc(stim_left);

% If we're considering the disparity betwen the 2 stimuli (left and right),
% the disparity would be 0 because they are both of the same image. 



%% 
% Finally, verify that the binocular_cell.m function you wrote works. Show
% the binocular cell responses to your stimulus with the following
% disparities:

disparities = -100:10:100;

% Use *apply_Gabors* to get the response of the simple cell to each image
% and pass this into *binocular_cell*. Make sure to use the version of
% *apply_Gabors* provided in this assignment. *apply_Gabors* will return a
% height_img, width_image, n_Gabor_sizes, n_orientations, n_phases matrix.
% Use only the first size and the vertical orientation for this exercise.
% Please rescale the response at each disparity with the maximal response
% across all disparities, in order to make the comparison significant. The
% responses represent cells tuned to different disparities. Are the
% disparities consistent with the veridical disparity you mentioned in the
% previous question? Could there be a problem?
%
% Show the output of each disparity. You should have 21 plots, each as
% its own subplot within a single figure.
%
% ===========TYPE YOUR CODE HERE================

filtered_maps = apply_Gabors( stim_left, filters_by_size );

%The first size, and orientation, but both phases
to_binoc = squeeze(filtered_maps(:,:,1,1,:));



% Create Binocular Cells
filtered_binocs = nan([size(to_binoc,1),size(to_binoc,2),size(disparities,2)]);
for d=1:size(disparities,2);
    filtered_binocs(:,:,d) = binocular_cell_template( to_binoc, to_binoc, disparities(d), 2 );
end

% Normalize Cells based on max
max_disp = max(filtered_binocs,[],3);
for d=1:size(disparities,2);
    filtered_binocs(:,:,d) = filtered_binocs(:,:,d) ./ max_disp;
end


for d=1:size(disparities,2);
    %Get binocular cell
    filtered_binoc = filtered_binocs(:,:,d);
    
    figure(d)
    colormap gray
    imagesc(filtered_binoc);
    title(strcat('Disparity: ', int2str(disparities(d)) ))

end

% Although everything looks good for disparity 0 ( because the images are
% the same ), its easily visible of a problem with disparity -100 and 100
% (and occurs within - to + all over). The filtered images between these
% disparities look exactly the same, which could cause considerable
% confusion in our models



%% Building absolute disparity units
% The units you built in the previous section are called 'tuned excitatory
% (TE)' units, because the cell is excited whenever the stimulus is
% presented to both eyes. It has also been shown that some binocular simple
% cells linearly combine the two monocular receptive fields by OPPOSING
% weights. These units are called 'tuned inhibitory (TI)'  because the
% cells are silent when stimulus is presented to both eyes. To compute the
% TI response, you need to compute:
%
%   TI = abs((L_0- R_0))^q + abs((L_90 - R_90))^q, where p = q = 1
% 
% The combination of TE and TI can provide a valuable bit of information.
% Try divisive normalization by applying the following operation on each
% element: 
%
%   TE/(sqrt(2) + TI)
%
% Fill in *absolute_disparity*, which should take in the response of the
% Gabors to a left and right stimulus, compute TE and TI, and perform the
% normalization. Note that the functions *absolute_disparity*  and
% *binocular_cell* are designed to deal with one Gabor size and one
% orientation at a time. When you actually apply this function to images,
% you will have to loop over Gabor sizes and orientations. See
% *absolute_disparity_template* for further instructions.
%
% =================SEE *ABSOLUTE_DISPARITY.M*======================

%%
% Finally, fill in the function *decode_disparity*, which should take in
% the results from *absolute_disparity* or *binocular_cell* for all Gabor
% sizes and orientations. This function should average over Gabor size and
% orientations, and then take the argmax over disparities to get a map of
% decoded disparities. See *decode_disparity* for further instructions.
%
% ================SEE *DECODE_DISPARITY*===========================

%% Loading the data
% We have provided you with a small subset of the Middlebury Dataset. The
% dataset includes left and right pairs for several images, along with a
% ground truth depth map for each image. Here, you should load the left and
% right maps for all 5 of the provided images. We have provided a function
% *load_and_preprocess*, which takes in a path to a directory containing
% all the images. You will have to do this for the left and right image
% directories separately. Paths are provided below.

left = './module6_resources/images_left';
right = './module6_resources/images_right';

% ===========TYPE YOUR CODE HERE================
left_imgs = load_and_preprocess(left);
right_imgs = load_and_preprocess(right);



%%
% Now, pick one pair of left and right images. Visualize them to get a
% sense of what you will be working with. Note that *left* and *right* are
% organized in the same order so left{1} and right{1} should correspond to
% the same scene. We recommend using the bicycle (image number 2 so
% left{2} and right{2}) to start. Once that is working, feel free to
% visualize other images.
%
% ===========TYPE YOUR CODE HERE================
bike_left = left_imgs{2};
bike_right = right_imgs{2};

title('Bikes')
subplot(1,2,1)
imagesc(bike_left)
subplot(1,2,2)
imagesc(bike_right)

%% Computing TE Alone
% Here, we will run the baseline energy model (*binocular_cell*) on the
% left and right images you selected above. The Gabors you create for this
% portion will be tuned slightly differently than in the past. Each Gabor
% size should use a different value for lambda and sigma. We have provided
% you with default parameters where sigma is a function of lambda, and
% lambda is a list with the same length and Gabor_size. Make sure you index
% into lambda and sigma with the same variable you use to index into
% Gabor_size. Make your new filters and use *apply_Gabors* to filter your
% left and right image.

Gabor_size = [7,19,29,39];
theta = [0, pi/4, pi/2, 3*pi/4];
psi = [0,pi/2];
lambda = [3.5,10.3, 16.8, 24];
sigma = lambda*.8; % Note, this creates a list where each lambda value is multiplied by .8. 
gamma = 1;

% ===========TYPE YOUR CODE HERE================
% 4x1 cell array where each cell is a matrix of size:
% gab_size x gab_size x num_orient x num_phase
filters_by_size = cell(numel(Gabor_size),1);
for i=1:numel(Gabor_size)
    filter_by_size = ones(Gabor_size(i), Gabor_size(i), size(theta,2), size(psi,2));
    for j=1:size(theta,2)
        for k=1:size(psi,2)
            filter_by_size(:,:,j,k) = simple_cell(Gabor_size(i), lambda(i), theta(j), sigma(i),gamma,psi(k));
        end
    end  
    filters_by_size{i} = filter_by_size;
end
          
left_bike_maps = apply_Gabors( bike_left, filters_by_size );
right_bike_maps = apply_Gabors( bike_right, filters_by_size );

%% Testing left bike maps
% 
% for x=1:4
%     subplot(2,1,1)
%     imagesc(left_bike_maps(:,:,x,1,1))
%     subplot(2,1,2)
%     imagesc(left_bike_maps(:,:,x,1,2))
%     pause(.5)
% end




%%
% Now, loop over Gabor size (dimension 3) and orientation (dimension 4) and
% apply *binocular_cell* to each. Use disparities 15 through 35 and p=2.
% You should end up with a final result that is height x width x
% n_Gabor_sizes x n_orientations x n_disparities

disparities = 15:35;


h = size(bike_left,1);
w = size(bike_left,2);
n_gabs = size(Gabor_size,2);
n_orient = size(theta,2);
n_dispar = size(disparities,2);
p = 2;


% ===========TYPE YOUR CODE HERE================
filtered_binoc = nan( h, w, n_gabs, n_orient, n_dispar );
% For each gabor size
for i=1:n_gabs
    % For each orientation
        for j=1:n_orient
            % h x w x 1 x 1 x p filtered map
            left_filt = left_bike_maps(:,:,i,j,:);
            right_filt = right_bike_maps(:,:,i,j,:);
        
            % For all disparities
            filtered_binoc(:,:,i,j,:) = binocular_cell_template(left_filt,right_filt,disparities,p);
        end
end
%% Visualizing Bike at different disparities
% for x=1:n_dispar
%     colormap gray
%     imagesc(filtered_binoc(:,:,1,1,x))
%     title(x)
%     pause(.3)
% end


%% Computing absolute disparity
% Now, you should do the same as you did above, but using
% *absolute_disparity* this time. You should have already filtered your
% images with the Gabors, so you may simply loop over Gabor size and
% orientation in your left and right responses and send the maps into into
% *absolute_disparity*. Use the same disparities as before, and use p=q=2.
% The result should be the same dimensions as the cell above.

% ===========TYPE YOUR CODE HERE================

p=2;
q=2;

filtered_abs = nan( h, w, n_gabs, n_orient, n_dispar );
% For each gabor size
for i=1:n_gabs
    % For each orientation
        for j=1:n_orient
            % h x w x 1 x 1 x p filtered map
            left_filt = left_bike_maps(:,:,i,j,:);
            right_filt = right_bike_maps(:,:,i,j,:);
            
            % For each disparity
                for k=1:n_dispar
                    filtered_abs(:,:,i,j,k) = absolute_disparity_template(left_filt,right_filt,disparities(k),p,q);
                end
        end
end


%% Visualizing Bike AD different disparities
% for x=1:n_dispar
%     imagesc(filtered_abs(:,:,1,1,x))
%     title(x)
%     pause(.3)
% end



%%
% Now, send both your TE and your AD result into *decode_disparity*.
%
% ===========TYPE YOUR CODE HERE================
decode_exc = decode_disparity_template( filtered_binoc );
decode_abs = decode_disparity_template( filtered_abs   );

%% Comparing Your Results
% Visualize your decoded results for both TE and AD. You will compare these
% with the ground truth images later in the assignment. For now, comment on
% which one you think looks better and why. Note: You might have artifacts
% around the edges of the image from the convolution. Do not worry about
% this.
%
% ===========TYPE YOUR CODE HERE================

figure(1)
imagesc(decode_exc)
title('TE Decoded')

figure(2)
imagesc(decode_abs)
title('AD Decoded')

% The AD looks quite a bit better with more gaps filled in all across the
% image. It?s clear that the front wheel of the bike is highlighted more
% than the back wheel, and that the background (which should be more
% constant throughout) is much darker, indicating it is even farther away.
% Overall the AD looks to be smoother in general.


%% Part 3 %%
%%%%%%%%%%%%
%% Comparing to ground truth
% We have provided you with ground truth disparity maps for all of the
% images in the dataset. Here, you should load the ground truth images for
% the left and right image you selected. We have provided you with the
% function *load_groundtruths* that takes in the path to a directory
% containing ground truth images and returns a cell array of loaded images.
% Compare these to the corresponding maps you produced above and comment.
% They are loaded in the same order as the left and right test stimuli, so
% if you used the bicycle image, you should visualize image 2 from the left
% and right groundtruth datasets. Note that the ground truths are in a file
% format that matlab does not naturally read, so you might see some white
% dots around the edges of the image. Disregard them.
%
% ===========TYPE YOUR CODE HERE================

ground_left  = load_groundtruths('module6_resources/ground_truth_left');
ground_right = load_groundtruths('module6_resources/ground_truth_right');

figure(1)
imagesc( ground_left{2} )
title('Ground Truth Right')
figure(2)
imagesc( ground_right{2} )
title('Ground Truth Left')

% Comments in writeup