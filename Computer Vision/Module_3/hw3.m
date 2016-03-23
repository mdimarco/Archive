%% Module 3: Pooling and Invariances
% Last updated: October 2015

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
%% Hard-coded filters using apply_gabors
% To begin this assignment, write a function that takes in an image and
% applies a specific set of hard-coded simple cells to the image and returns a
% matrix of filter maps. If you are unfamiliar with the term "hard-coded",
% it just means that theyre written directly in the function instead of
% being passed in as a parameter.
% 
% Each map in the output of this function corresponds to a family of cells.
% Each family of cells has a different optimal stimuli based on phase and
% orientation. Normally, modeling a simple cell would require
% rectification following filtering. However, you should not rectify in
% this case because later in the assignment we will be transforming output
% into a quadrature.
% 
% This all must be in a separate matlab function because you will use it
% several times throughout the lab. You should use of *apply_gabors()*
% within this function, so remember to copy the *apply_gabors.m* file from
% your Assignment 1 into your Assignment 3 folder. We have provided you a
% stencil for this function called *population_simple_cells_template*.
% There are specific instructions on how to structure your code inside of
% the stencil.

% ========= FILL IN population_simple_cells_template.m =====================

addpath('template_functions');
image = imread('resources/test_image.jpg');
image_gray = rgb2gray(image);
maps = population_simple_cells_template( im2double(image_gray) );


%% Part 2 %%
%%%%%%%%%%%%


%% Creating Complex Cells
% In this assignment, we are going to look at how complex cells can be
% modeled.
%%
% First, we're going to add an energy model to the simple-cell gabor units
% to produce a phase-invariant model of complex cells. Start by making a
% vertical bar test stimulus.  To do this, you should use the function
% *create_bar* that you filled in during Assignment 1. This function should
% have the form: stimuli = create_bar(bar_length, bar_width, rot_angle,
% x_offset, img_size). Use a vertical bar for this exercise.
% 
% Again, we use the term 'simple cell' loosely here, since usually
% rectification would be required for a full simple cell model.
%
% You should also create a complement to this stimulus with a different
% phase. To do this, take the stimulus you just made, and pass it into the
% function *imcomplement()*. You  should end up with 2 test stimuli.
% Visualize the stimuli to ensure they are indeed complements.

% ============TYPE YOUR CODE HERE===============
addpath('template_functions');
addpath('resources');
image = imread('resources/test_image.jpg');

stimulus = create_bar(20, 60, 90, 0, 200);
stimulus2 = imcomplement( stimulus );


figure(1)
imagesc( stimulus )

figure(2)
imagesc( stimulus2 )

%%
% Next, pass each bar stimulus into **population_simple_cells*, which you
% should have filled in during the prep-portion of this assignment.

% ============TYPE YOUR CODE HERE=================

stimulus1_maps = population_simple_cells_template( stimulus );
stimulus2_maps = population_simple_cells_template( stimulus2 );

%% 
% Create two figures, one for each stimulus, with each showing the response
% of population_simple_cells for both phases (psi = 0, psi = pi/2), with a
% vertically-oriented Gabor filter. Comment on what you see. How do the
% responses for the two stimuli differ? Why do you think that is?

% ============TYPE YOUR CODE HERE=================

%The response for the two stimuli don't seem to differ, which makes sense
%given they are simply image complements of each other. The interesting
%difference is that of the phase 0-pi/2, which has an inverse activation on
%the edges of the bar. I think it does this out of the nature of a gabor
%function's positive and negative regions being shifted by the phase.

subplot(2,2,1);
imagesc( stimulus1_maps(:,:,1,1) );
title('stimulus 1 phase 1')


subplot(2,2,3);
imagesc( stimulus1_maps(:,:,1,2) );
title('stimulus 1 phase 2')

subplot(2,2,2);
imagesc( stimulus2_maps(:,:,1,1) );
title('stimulus 2 phase 1')

subplot(2,2,4);
imagesc( stimulus2_maps(:,:,1,2) );
title('stimulus 2 phase 2')


%%
% Now you'll use the output of the simple cells to produce the output of a
% phase-invariant complex cell using the energy model (explained in the
% template code). You should write your code in the provided stencil
% function *energy_model_template*. *energy_model* takes in the output of
% *population_simple_cells* and combines the maps from different values of
% psi for each orientation using the energy model. Specific instructions
% are written in the stencil code.

% =========== FILL IN ENERGY_MODEL_TEMPLATE.M NOW===========

%%
% Pass the maps you obtained from *population_simple_cells* to
% *energy_model*. This should give you a single complex cell response each
% orientation. Make sure you do this for both stimuli: the original and its
% complement. 

% ===========TYPE YOUR CODE HERE================
cmplx_maps1 = energy_model_template( stimulus1_maps );
cmplx_maps2 = energy_model_template( stimulus2_maps );

%%
% Create 2 figures: The first figure should show the response to the
% vertical bar and its complement BEFORE the energy model is applied. Use
% vertical orientation and psi = 0.
% 
% The second figure should show the response to the vertical bar and its
% complement AFTER the energy model is applied. Use vertical orientation.
% Comment on what you notice.

% ===========TYPE YOUR CODE HERE================

phase = 1;

%Simple, 1 phase response
figure(1)
subplot(2,1,1)
imagesc( stimulus1_maps(:,:,1,phase) );
title('stimulus 1, phase 1')
subplot(2,1,2)
imagesc( stimulus2_maps(:,:,1,phase) );
title('stimulus 2, phase 1')

%Complex, energy model response
figure(2)
subplot(2,1,1)
imagesc( cmplx_maps1(:,:,1) );
title('stimulus 1, phase invariant')
subplot(2,1,2)
imagesc( cmplx_maps2(:,:,1) );
title('stimulus 2, phase invariant')

%The edges that were missed by the original stimulus ( 1 phase ) were
%picked up by the new complex cell model, which takes into account both
%phases.


%% 
% Now we'll add local normalization to our model, also known as local
% feature strength normalization. This process should boost the complex
% cell's response to weaker signals. Below, we've provided a stimulus with
% two vertical bars sitting next to each other: the vertical bar on the
% left is a much weaker stimulus than the vertical bar on the right.

stim3 = [create_bar(2,10,90,0,50), create_bar(2,10,90,0,50).*6];

%% 
% First, visualize the stimulus containing two bars: 

% ==============TYPE YOUR CODE HERE=============

%NOTE: these both look the same because the above has .*6, which multiplies
%the right side to be 6 times stronger than the left, but both seem to be
% %maxed out in the plot's brightness regardless
% subplot(2,1,1)
% stim3_weak = stim3(:,1:50);
% imshow(stim3_weak)
% subplot(2,1,2)
% stim3_strong = stim3(:,51:end);
% imshow(stim3_strong)

imagesc(stim3)
%%
% Next, repeat the steps we performed on the other stimuli in this
% assignment. Namely, pass the stimulus into population_simple_cell and
% passing the result into *energy_model*. This is your baseline complex
% cell.
%
% Show the output for both steps of the process implemented on this
% stimulus: 1) the output of population_simple_cells, and 2) the output of
% energy_model. Compare the two outputs. What differences do you notice?
% What role is the energy function playing in our model?

% =============TYPE YOUR CODE HERE==============

%Simple
stim3_maps = population_simple_cells_template( stim3 );

%Simple Cell Plots
figure(1)
subplot(2,1,1)
imagesc(stim3_maps(:,:,1,1));

title('Simple Cell Phase 1')
subplot(2,1,2)
imagesc(stim3_maps(:,:,1,2));
title('Simple Cell Phase 2')

%Complex
stim3_cmplx_maps = energy_model_template( stim3_maps );


%Complex Cell Plots
figure(2)
imagesc( stim3_cmplx_maps(:,:,1) )
title('Complex Cell Phase Invariant')

%The energy function is combining the results of both phases of the
%stimulus to react on a larger field than before

%%
% Now that we have our phase invariant complex cell, add local
% normalization. To do this, you should fill in the stencil
% *local_norm_template*. This function should take the output from
% *energy_model* and the size of a desired local neighborhood and normalize
% each of the maps according to the normalization scheme specified in the
% stencil file.

% ==============FILL IN LOCAL_NORM_TEMPLATE.M NOW================
% 
%%
% Pass in the response of your phase invariant complex cell to *stim* into
% *local_norm*. To start, set the size of your neighborhood to 5. Visualize
% the vertical cell output before and after you apply *local_norm* and
% comment on what you notice. 

% =============TYPE YOUR CODE HERE=================

subplot(2,1,1)

imagesc( stim3_cmplx_maps(:,:,1) )
title('Complex Cell Phase Invariant')

normd = local_norm_template( stim3_cmplx_maps, 5 );

subplot(2,1,2)
imagesc( normd(:,:,1) )
title('Complex Cell Normalized')

%% 
% Finally, we'll add max-pooling to produce a translation-invariant
% model of complex cells. To do this, take the vertical orientation
% output of the local_norm and apply the given function
% *maxPool.m*. Read the function's comments in order to use it correctly.

pool_size = 5;

% ===========TYPE YOUR CODE HERE==================
trans_invariant = maxPool( normd(:,:,1), 5 );
imshow(trans_invariant)

%%
% Now, create a dataset of shifted bars. You should use *create_bar* and
% vary the x_offset parameter. We've provided some default parameters:

bar_length = 2;
bar_width = 10; 
rot_angle = 90;
img_size = 50;
shift = [-20,-15,-10,-5,0,5,10,15,20];

% ==========TYPE YOUR CODE HERE===================
bars = cell( 1, size(shift, 2) );
for x = 1:size(shift, 2)
    bars{x} = create_bar( bar_length, bar_width, rot_angle, shift(x), img_size );
end


%%
% Use this dataset to produce a tuning curve for ONLY your
% translation-invariant complex cell (don't apply the other functions in
% this exercise before applying maxPool.m, i.e. pass your stimuli straight
% into maxPool). To do this, run each image in the dataset through maxPool
% with pool_size = 5. Finally, create a tuning curve by plotting the
% response of the center pixel of the map corresponding to horizontal
% orientation against the value of x_offset. What do you notice?

% ==========TYPE YOUR CODE HERE===================

%% Part 3 %%
%%%%%%%%%%%%
%% Comparing These Models
% Show the output for all 4 models (Gabor, Gabor+energy,
% Gabor+energy+normalization, Gabor+energy+normalization+maxpooling) on the
% image 'test_image.jpg' and comment on the significance of such models for
% contour detection. When doing these visualiations, pick a single
% orientation and visualize this orientation at each step instead of
% visualizing all for orientations. Be sure to convert the image to
% grayscale.
%
% Tip: Try different values for your neighborhood size in normalization and
% your pooling size in maxpooling to get the best results.

% =============TYPE YOUR CODE HERE=================
test_image = im2double( imread('resources/test_image.jpg') );


test_image_gabors = population_simple_cells_template( rgb2gray(test_image) );
subplot(2,2,1)
imagesc( test_image_gabors(:,:,1) );
title('Gabors')

test_image_gabors_energy = energy_model_template( test_image_gabors );
subplot(2,2,2)
imagesc( test_image_gabors_energy(:,:,1) );
title('Gabors+Energy')

test_image_gabors_energy_normalized = local_norm_template( test_image_gabors_energy, 5 );
subplot(2,2,3)
imagesc( test_image_gabors_energy_normalized(:,:,1) );
title('Gabors+Energy+Normalized')

test_image_gabors_energy_normalized_maxpool = maxPool( test_image_gabors_energy_normalized, 5 );
subplot(2,2,4)
imagesc( test_image_gabors_energy_normalized_maxpool(:,:,1) );
title('Gabors+Energy+Normalized+Maxpool')