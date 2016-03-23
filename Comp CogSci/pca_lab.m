


%Mason DiMarco -- mdimarco


%% Principal Component Analysis
%
%% 1. Getting started with PCA
% To help you understand how PCA works, you will first start with a toy 2D
% dataset which has one direction with a large variance and another with
% a small variance. You will visualize what happens when you use PCA to
% reduce the data from 2D to 1D. In practice, you might want to reduce data
% about 1-2 order of magnitudes in the number of dimensions (from ~10^4 to
% ~10^2-10^3 dimensions).

%%
% Load the dataset
load('data/faces')
%%
% Generates data with a mean M=[-1 2] and covariance SIG=[1 2; 2 5] as done in class. 
DATA = mvnrnd([-1 2], [1 2; 2 5], 100);

%%
% Plot the raw data using the *scatter* command. What do you notice? (do
% not close the window).

% Your code goes here
x = DATA(:,1);
y = DATA(:,2);
scatter(x,y);
hold on
%This will have 100 randomized datapoints that will be centered at the mean
%and rotated counter-clockwise



% Run PCA on the data set

% Your code goes here
coeff = pca(DATA);



% Now plot the two principal components (PCs). To accomplish this, you'll
% need to plot each PC as a line passing through a point from a vector. The
% *plot* command can take two matrices as inputs and will plot a vector
% using the columns/rows of these matrices. To create a line representative
% of points in a vector, you can multiply each of the *plot* command's inputs by an
% array that converts the PC to two endpoints of a line (like [-15
% 15] for instance). The plot command will connect the endpoints to create
% a line. Try making each PC a different color and remember to label the
% axes and set the fonts to an appropriate size.

% Your code goes here
z = zeros(1,1);

plot( [ z coeff(1,:)]  , [ z coeff(2,:)]);

%%
% Now project the data in eigenvector space. Think about how this compares
% to the initial scatter plot you made of the raw data.


%this projection aligns the data so that we can clearly see the variance
%across the eigenvectors along the x and y coordinate planes
% Your code goes here





proj = DATA*coeff;
scatter( proj(:,1), proj(:,2) );
%%
% Drop one of the principal components and project back into the original
% space. What do you notice?


%Projecting back on to the original space but
% removing the second principle component, so the only variance we see is
% along the 1st principle component. 

%Your code goes here
back = proj*[coeff(1,1) 0; coeff(2,1) 0]';
scatter(back(:,1),back(:,2))

%% 2. PCA with different types of data

% Begin by downloading the data set available
% <http://www.cs.columbia.edu/CAVE/databases/SLAM_coil-20_coil-100/coil-100/coil-100.zip
% here>. This is a database from the Columbia Object Image Library (COIL)
% that contains color images of 100 objects that were photographed from
% several angles on a motorized turntable.

%%
% These lines point to your copy of COIL-100 and prepare variables you will
% need in order to visualize these images

% Your code goes here
files = dir('/Users/masondimarco/Documents/MATLAB/coil-100');

%%
% Before visualizing, you'll need to use a for-loop to access
% each of the .png files in the data set. Read the images from the file one
% at a time and then save the images in the DATA variable created above.
% Between these steps you'll need to use the following command
% *histeq(imresize(rgb2gray(img), [nSiz nSiz]))* which is a step for
% pre-processing and helps to normalize the image contrast so we can
% visualize something meaningful.

% Your code goes here
new_size = 32;
DATA = zeros(numel(files)-4, new_size*new_size);
for i = 4:numel(files)
   len = numel(files(i).name);

   if len > 3 && strcmp(files(i).name(len-2:end),'png') == 1 
       this_image = imread(fullfile('/Users/masondimarco/Documents/MATLAB/coil-100',files(i).name ),'png');
       this_image = imresize(histeq(rgb2gray(this_image)), [new_size,new_size] );
       DATA(i-4,:) = this_image(:);
   end
end


%%
% Now run PCA on the data set you produced from the above for-loop

% Your code goes here
coeff = pca(DATA);


%%
% Visualize some of the first principal components (for example the 25
% first) of these images. What do you see?


%The first 25 principle components! Basic building blocks that would be put
%together to form the various objects in the files, this looks like it has
%them from different angles, as the objects are oriented, as well.


% Your code goes here
axis image
colormap gray
for ii = 1:25
       
    subplot(5,5,ii);
    imagesc(reshape(coeff(:,ii),[new_size,new_size]));
    title(num2str(ii));
    axis off;
    
end


%% 3. PCA and eigenfaces
% Begin by loading the dataset available on CANVAS in Modules or here:
% <https://canvas.brown.edu/courses/957516/files/47118197/download>
% which will load the faces dataset into the workspace. The faces variable
% contains a large matrix where images are organized as row vectors (each
% row contains a 361 dimensional vector corresponding to a 19 x 19 image.

% Your code goes here
faces = load('data/faces');
%%
% You can visualize each of the data points by
% using the *reshape* command on a row of the matrix to convert rows back into square
% matrices, then by using *imagesc*. The faces variable is the set of
% images that you will use to learn a "face space".
%
% Display a few faces (you can use *colormap(gray)* and *axis image* to
% make your figures prettier)

% Your code goes here
face_size = 19;
axis image
colormap gray
for ii = 1:16
   
    face = reshape(faces.faces(ii,:), [face_size,face_size]);
    subplot(4,4,ii)
    imagesc(face)
    axis off
    
end

%%
% Run a principal component analysis on the faces dataset (preprocess
% the dataset by appending mirrored symmetric faces like in class).
% Retrieve the principal components (a.k.a. eigenfaces) and the variability
% associated with each PC (these should respectively be the first and third
% output arguments of *pca*).

% Your code goes here
[eigen_faces, score, variance] = pca(faces.faces);

%%
% Why are there 361 principal components? Answer this as a comment in your
% script.

%This is 361 dimensional data (19*19), because it is made up of 361 pixels,
%there are 361 dimensions of changes that can be performed.

%%
% Project one of the data points (one of the rows from faces) into the
% principal component space, reshape it to be a 19x19 matrix and show the
% resulting image. Does it look like a face? If not, why?
%
% _Hint: if PC is the matrix of principal components, and r is a row of a
% matrix of data points in the original space (i.e. you can reshape r into
% square form and see a meaningful image), you can project r into the
% principal component space by doing: r_in_pc_space = r * PC._


%It represents a position in the basis of the eigenfaces, which means it
%actually is still the face, just projected into a basis that is
%unrecognizable, as it is a different basis then we are used to seeing.

% Your code goes here
colormap gray;
PC = faces.faces;
imagesc( reshape( PC(2,:)*eigen_faces, [face_size, face_size]) )

%%
% Determine the smallest number *n* of the top principal components (in
% terms of variance explained; or the third output argument of *pca*) you
% have to keep in order to account for at least 95% of the total variance.
%
% _Hint: *pca* returns principal components already sorted by decreasing
% amount of variance explained, so you just have to use the variability of
% each principal component and *cumsum* to determine the smallest number of
% components that account for at least 95% of total variance. The *find*
% command will also be helpful._

% Your code goes here
tot = sum(variance);
variance_counter = 0;
i = 0;
while (variance_counter/tot) < .95
   i = i + 1;
   variance_counter = variance_counter + variance(i); 
end  
fprintf('%d\n',i)
%%
% Show the first *n* principal components you determined above as images.
% What properties do each eigenvector seem to code for?


%First, we start with things that actually look like faces, this makes
%sense, as most faces share these common properties, noses are
%recognizable, as are lips, and spots for eyes. It seems like 1 and 2 might
%be variable on the lighting, 3 might have to do with the person's eyes,
%and 8 might have to do with the person's mouth. As we get down to the 80's
%there are less recognizable features. These are pieces that have less
%"weight" towards the creation of a face, but that still contribute some
%similarities to the facial recognition. It's harder to see these, of
%course, as they contribute much less.

% Your code goes here
for jj = 1:i
    face = reshape(eigen_faces(:,jj), [face_size,face_size]);
    subplot(9,10,jj)
    imagesc(face)
    title(num2str(jj))
    axis off
end    