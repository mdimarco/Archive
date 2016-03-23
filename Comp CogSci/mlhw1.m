

%Mason DiMarco


%% MDS
% 
% Last updated: January 2015

%% 1. Introduction to MATLAB
% Author: Jonathan Nicholas
% Last updated: January 2015
%
% The goal of this exercise is to familiarize yourself with the MATLAB
% environment and to learn some basic commands. Don't be scared if you've 
% never seen a code editor before - this exercise will walk you through what
% you need to know to get started.
%
% This assignment is due by the start of the first lab on 1/28. You'll need
% to copy/paste the code portions into a MATLAB script to run them. Turn in
% that MATLAB script (.m file).

%% 1. a. Variables
% You know what variables are in a math equation. Take this one: 
%%
%    y = 2x + 4x + 6.
%%
% What are the variables?

%%
%
% In an equation, the 'x' and 'y' are like placeholders that equal some
% other value. Variables do this same basic thing in coding: they are
% placeholders that represent a value. A variable can be set equal to a
% bunch of different things and you can change those things very easily.
%%
% Say I have a grocery store and I want to write a program
% that takes inventory of my produce. I have 13 bananas, 4 apples, and 6
% grapes. Let's use variables to accomplish this:

bananas = 13;
apples = 4;
grapes = 6;

%%
% *Run this code and type 'bananas' (minus the ''s) in the editor
% window.*
%%
% Look at what it reads out. It should be the value we just set 'bananas' to.
%%
% You've just created some variables. MATLAB will remember that each variable you
% make is equal to the value you pass to it. Variables can also be
% overwritten.
%%
% *In your script, write a line of code that sets bananas equal to any
% number other than 13.*
bananas = 10;
%%
% *Now type 'bananas' into the editor again.*
%%
% It should now be the value you just set 'bananas' equal to - it no longer equals 13. You've overwritten the
% variable to equal a new value. MATLAB will always remember the value that
% has most recently been set equal to a variable.
%%
% Variables are important because you can use them in many different places
% in your code and they will always equal the last value you set them to.
% This is very important.
%%
% *To see how this works, run the following line:*

bananas = bananas + 10;

%%
% This line takes the variable 'bananas' at its current value, adds 10 to
% it, and then sets it equal to bananas again. We've updated the variable
% without having to remember the number of bananas we had previously. You
% can see how this might be helpful in a real grocery store where there are
% many more bananas and tons of transactions happening all the time. You
% only need the one variable to keep a running tally of how many bananas
% are actually present.
%%
% *Now add some more apples and grapes in your MATLAB script.*
apples = apples + 10;
grapes = grapes + 10;
%%
% These are the basics of how variables work. You should keep in mind that the
% way you name your variables is important for them to be useful. They
% should generally describe what they contain so that you can remember what
% to use them for.

%% 1. b. Arrays
%
% Knowing the number of items in a grocery store isn't very useful for our
% purposes. A lot of times we want to store more complicated information in
% a variable. This is where data structures come in handy. A data structure
% is simply a way that MATLAB internally stores the relationships of a set
% of data to one another. One of the most common data structures that we'll
% be relying on heavily in this class is an array. An array stores multiple
% values of a variable (or even multiple variables). In MATLAB, arrays are
% synonymous with matrices. Arrays are indicated by the use of brackets [ ].
%%
% Let's say we want to measure time from 1 to 5 seconds. All we need to do is create a
% variable and set it equal to an array with these five values stored
% within it:

time = [1 2 3 4 5];

%%
% *Run this code and type 'time' in the editor.*
%%
% You can see that the variable is equal to all 5 of these values.
%%
% Arrays can also be created using colons:

time = 1:5;
%%
% *Run this code and take note of its output.*
%%
% Colons are good for evenly spaced intervals and will create an array full
% of the numbers from x:y. This is extremely useful for large numbers. x
% and y can also be any numbers (your array doesn't have to start with 1).
%%
% *In your script, create a really big array using a colon.*
%%
% Additionally, you can specify intervals with colons.
%% 
% *Run the following lines and take note of their respective outputs:

time = 1:2:9;

time_countdown = 10:-2:0;
%%
% When you use two colons, the outer numbers specify the range of numbers
% you would like to fill the array with. The center number specifies the
% interval in between each number in the array. You can also populate an
% array in ascending or descending order.
%%
% These arrays have all been 1 dimensional so far. It is possible (and
% useful) to create arrays as 2D matrices. In MATLAB, a matrix is read as
% a row and then a column. To create a 3x5 matrix, copy/paste the followign
% in your script.

threebyfive = ones(3,5);
%%
% The ones() command populates the entire array with ones at the specified
% dimensions (row, column) that you pass to it. You can change any location
% in the array to another value by accessing a specific location in the
% array:

threebyfive(1,5) = 3;
%%
% which changes the location to 3. You can access any specific location in the array by specifying the arrayname(row location, column location)
%%
% or you could change all of the values in the array to another number:

threebyfive_2 = 2 * ones(3,5);
%%
%which creates a 3x5 matrix full of 2's
%%
% You could also create an array full of zeros:

threebyfive_0 = zeros(3,5);
%%
% The zeros(a,b) and ones(a,b) commands are useful for creating matrices of
% a given (row,column). You can always change the values of any location
% later.
%%

% Make an 7 x 8 array full of ones in your script.
%%

% Now change the value in the 6th row and 4th column to equal 4.
%%
% Arrays/matrices will be used extensively in this class. Play around with
% these functions until you feel like you understand them.

%% 1. c. Comments
%
% The % sign is used to create a comment in MATLAB. Comments are portions
% of your code that are not run and can therefore be used to communicate
% information about how your code works. Comments are important! They help
% whoever is reading your code understand what is happening.
%%
% Here is an example of a good comment:

hello = 'I AM MATLAB'; %Stores the string 'I AM MATLAB' in the variable hello
%%

% And here is a bad comment:
identity_crisis = 'WHO AM I?'; %Makes these things equal

%%
% Comments help us understand whether you know what your code actually does
% or not.
%%
% In your script, write a line of code (it can do anything!) with a good
% comment.

identity_3 = eye(3) %I make a 3x3 Identity matrix!
%% 1. d. Finishing up

% These are some of the basics you'll need to understand to complete your
% assignments in this course. If you had trouble with any of the parts,
% feel free to email me at jonathan_nicholas@brown.edu and I'll help answer
% your questions.


%% 2. Multidimensional scaling 
%
% In this assignment we will be using two datasets:
% <https://canvas.brown.edu/courses/957516/files/44784734/download Animals>
% and
% <https://canvas.brown.edu/courses/957516/files/44784733/download Colors>
% The variable 'names' is a cell array containing the names of animals and the
% wavelengths of colors (you can get an idea of what colors these
% correspond to using the table at http://en.wikipedia.org/wiki/Color).
% The variable dsim is a matrix of the dissimilarities among the
% animals/colors animals, based upon human judgments (these dissimilarities
% have been adjusted to be on a scale from 0 to 1; 1 means two elements are
% most dissimilar, whereas 0 means that two elements are least dissimilar,
% that is, 0 means they are identical).

%%
% Load the variables for the colors dataset into the workspace (names and
% dissimilarity matrix) -- NB: Naming convention: Try to use the naming
% convention described here http://www.ee.columbia.edu/~marios/matlab/MatlabStyle1p5.pdf

% Fill in code here
colors = load('data/Colors.mat');


%%
% Visualize the dissimilarity matrix using the command
% *imagesc(colorDsim);* where colorDsim is the name of the variable that
% contains your dissimilarity matrix followed by the *colorbar;* command. 
% You can plot the color names on the x and y axes using the *set(gca, 'XtickLabel',colorNames)* command

% Fill in code here
imagesc(colors.dsim);
colorbar;

set(gca, 'YtickLabel', colors.names);
set(gca, 'XtickLabel', colors.names);
%%
% Run multidimensional scaling to reduce the dissimilarities to two dimensions


% Fill in code here
dim2_version = mdscale( colors.dsim, 2 );
%%
% You can use the *scatter* command on the MDS results from MATLAB in conjunction with the *text* command to add the color names at each of the point locations to get a 2-dimensional representation of the dissimilarity between the colors.
% Produce scatter plots of Colors and their dissimilarities

% Fill in code here
scatter( dim2_version(:,1), dim2_version(:,2) );
text( dim2_version(:,1), dim2_version(:,2), colors.names);
%%
% To go from a similarity to a dissimilarity matrix, one just needs to
% subtract the former from 1 to get the latter, and vice-versa.
% Plot the similarity values measured as a function of the recovered
% distances in psychological space and comment.
imagesc(1-colors.dsim);

% First we retrieve the (Euclidean) distance matrix

% Fill in code here

color_dist_mat = squareform(pdist( dim2_version ));
color_dist_vec = color_dist_mat(:);
color_sim = 1-colors.dsim;
color_sim_vec = color_sim(:);

% Then we convert the distance matrix and the dissimilarity matrix as
% vectors, to plot them easily (as distance/dissimilarity matrices are
% symmetrical, we only need the upper triangular part, so we use logical
% indexing and the function triu).

% Fill in code here
scatter( color_dist_vec, color_sim_vec );
 

%%
% Plot the experimental similarity measures against the distances in the
% psychological scape using the *scatter* command

% Fill in code here

%% 3. Take-home: repeat section 1. on the animals dataset

% Fill in code here (tip: it should be similar to the code in 2.!)
animals = load('data/Animals.mat');
%%
imagesc(animals.dsim);
colorbar;
set(gca, 'YtickLabel', animals.names);
set(gca, 'XtickLabel', animals.names);

%%
md2Animals = mdscale( animals.dsim, 2 );
%%
scatter( md2Animals(:,1), md2Animals(:,2) );
text( md2Animals(:,1)+.015, md2Animals(:,2), animals.names);
%%
animals_sim = 1-animals.dsim;

animalDistMat = squareform(pdist( md2Animals ));
animalDistVec = animalDistMat(:);
animalSimVec = animals_sim(:);


scatter( animalDistVec, animalSimVec );
xlabel('Distance')
ylabel('Similarity')
