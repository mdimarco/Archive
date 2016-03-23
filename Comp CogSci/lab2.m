
%Mason DiMarco


%% MDS and Hierarchical Clustering
%
% Last updated: January 2015
%% 1. Hierarchical clustering and MDS
%
% In this pre-lab assignment we'll be using the same two datasets from last week:
% <https://canvas.brown.edu/courses/957516/files/44784734/download Animals>
% and
% <https://canvas.brown.edu/courses/957516/files/44784733/download Colors>
% but instead of MDS we'll be performing hierarchical clustering.
%%
% The variable 'names' is a cell array containing the names of animals and the
% wavelengths of colors (you can get an idea of what colors these
% correspond to using the table at http://en.wikipedia.org/wiki/Color).
%%
% The variable dsim is a matrix of the dissimilarities among the
% animals/colors animals, based upon human judgments (these dissimilarities
% have been adjusted to be on a scale from 0 to 1; 1 means two elements are
% most dissimilar, whereas 0 means that two elements are least dissimilar,
% that is, 0 means they are identical).
%%
% Load the variables for the colors dataset into the workspace like in the
% last assignment (names and dissimilarity matrix)

%Fill in code here
colorData = load('data/Colors');
names = colorData.names;
dsim = colorData.dsim;
%%
% For hierarchical clustering we will use the command *dendrogram(linkage(squareform(dsim)), numel(names), 'labels', names)*, which will return a tree-like structure, a dendrogram, with the names of the animals/colors appearing at the bottom (the leaves of the tree), and the lines indicating the point at which different animals/colors are clustered together. The distance or dissimilarity between two objects (at the bottom of the tree) is, intuitively, the number of nodes on the path going from one object to the other. Consequently, the lower the lines join, the more similar the objects being connected.
%% 
% Run hierarchical clustering and draw the color dendrogram

%Fill in code here
dendrogram(linkage(squareform(dsim)), numel(names), 'labels', names)
%%
% Now repeat the above for the animals dataset

%Fill in code here
animalData = load('data/Animals');
names = animalData.names;
dsim = animalData.dsim;
dendrogram(linkage(squareform(dsim)), numel(names), 'labels', names)

%% 
% Comment on how well the spatial representation returned by the MDS (last assignment) and hierarchical clustering capture your intuitions about the similarity between colors and animals. Was there a difference in which kind of representation seemed to capture your intuitions about the similarity of animals and the similarity of colors? Why do you think this is? Name two more kinds of stimuli that you think would be represented best using hierarchical clustering, and two more kinds of stimuli that you think would be best captured by a spatial representation.

%Write your comment here
%It seems pretty accurate, at least for these cases, as hierarchical
%clustering to be doing a good job. In my mind, "chimp" and "gorilla" are
%pretty closely intertwined, especially compared to a rhino which is found
%on the further side of the dendrogram. Although both mds and hierarchical
%clustering seem to be doing similar things, the visualization of the
%dendrogram seems more useful for the example of animals (at least it is
%more intuitive to interpret). It seems like mds is very useful for a
%gradient "look at it like a number line" approach to viewing data, where
%as H.C. is more of a grouping an classification technique for creating
%categories. Hierarchical clustering would  be useful for
%classifying a bunch of images of humans by their individual body parts, or
%taking in sounds and classifying them into phenomes; whereas spatial  
%representations may be better for mapping out people's social network 
%based on facial recognition (longer time to recognize, less they know the
%person) or plotting participants' findings in a study where they are asked
%how similar/different objects "feel" with respect to other objects
%% 2. Multidimensional scaling with published data
%
% Let's work with a large set of published data from a real research paper. Look at Kriegeskorte et al. (http://www.cell.com/neuron/abstract/S0896-6273(08)00943-4) to understand the background for this source data. 
%%
% We will again be using two datasets, both of which are linked <https://canvas.brown.edu/courses/957516/files/44784735/download here>
%%
% Note: There are 92 elements compared by each dissimilarity matrix (so it is a 92-by-92 matrix) -- an element is an object that is viewed by the monkey or the human subject, such as an animal's face or an inanimate natural object like a banana. Each of the 92 elements can belong to one of the 6 categories. The labels array maps each of the 92 elements in order to its corresponding category. Be sure that the sample points in your figures get assigned to the proper category! The category names (a variable called catNames) and the labels (a variable called labels) should already be in your workspace. There are six categories:
%%
% # hb - human body
% # hf - human face
% # nb - animal body
% # nf - animal face
% # in - inanimate natural
% # ia - inanimate artificial
%%
% Let's visualize the dissimilarity matrices and ensure that their
% visual representation makes sense. Check your work against Figure 1 in
% Kriegeskorte et al., for both the human and the monkey data.
%%
% Load the datasets from the data directory and extract specific data

%Fill in code here
data = load('rdm'); 
dsim_human = data.human_dsim;
dsim_monkey = data.monkey_dsim;


%%
% Convert the matrices to probabilistic square matrices

%Fill in code here
[sorted_man, indices] = sort( unique(dsim_human(:)));
percentiles_human = 100* (indices  / max(indices)); 

[sorted_monkey, indices] = sort( unique(dsim_monkey(:)));
percentiles_monkey = 100*(indices / max(indices)); 

%%
% Plot ds1_prob and ds2_prob as heat maps using imagesc
perc_monk = zeros(92,92);
perc_hum = zeros(92,92);

for x = 1:92
    for y = 1:92
        monk_val = dsim_monkey(x,y);
        Ind_monk = find( unique(dsim_monkey)==monk_val);
        
        hum_val = dsim_human(x,y);
        Ind_hum = find( unique(dsim_human)==hum_val);
        
        perc_monk(x,y) = Ind_monk*100/101;
        perc_hum(x,y) = Ind_hum*100/101;
    end
end

%Fill in code here
imagesc(perc_monk);
imagesc(perc_hum); 
colorbar;
%% 
% We want to visualize how each element relates to one another. We'll use
% MDS again (re-use and adapt the code you wrote before); this time,
% instead of using scatter(), use the *gscatter()* command. gscatter()
% enables you to plot data points with different colors, depending on each
% one's category. gscatter() has almost the same syntax as scatter(),
% except that the last argument you provide should be "cellfun(@str2num,
% labels)", which contain each data point's label (e.g., "gscatter(arg1,
% arg2, cellfun(@str2num, labels))"). (Note: cellfun(@str2num, labels)
% transforms labels, an array of strings, into an array of numbers, which
% is what gscatters wants).
%%
% For each of the two datasets (monkey and human):




%%
% Run multidimensional scaling to obtain a 2-dimensional solution,
% and plot the results with labels for each point. Comment.

%Running mds just like last time, but as can be seen, there are some
%clusters that show an overall correlation between the humans and monkeys
%for each of the 6 categories
human_mds  = mdscale( dsim_human, 2 );
monkey_mds = mdscale( dsim_monkey, 2 );


subplot(2,1,1),gscatter(human_mds(:,1), human_mds(:,2), data.labels);
subplot(2,1,2),gscatter(monkey_mds(:,1), monkey_mds(:,2), data.labels);



%Fill in code here
%%
% Plot the similarities measured as a function of the recovered
% distances in psychological space and comment.
%Fill in code here

human_dist_mat = squareform(pdist(human_mds));
monkey_dist_mat = squareform(pdist(monkey_mds));

sim_human = 1 - dsim_human;
subplot(2,1,1), scatter(human_dist_mat(:), sim_human(:));
xlabel('distance');
ylabel('similarity');

sim_monkey = 1 - dsim_monkey;
subplot(2,1,2), scatter(monkey_dist_mat(:), sim_monkey(:));
xlabel('distance');
ylabel('similarity');
%Monkeys really do seem a bit scatter brained
%There's a less tight correlation between distance and similarity rating in
%monkeys, possibly from a neurological difference?

%% 3. Hierarchical clustering with published data
% Run hierarchical clustering on the dataset and draw the dendrogram.
% Compare to figure 4 in Kriegeskorte et al. Please comment on any differences.

%Because we did percentiles by indices, we didn't wind up with the same
%results as the paper. We did, however, get to see that with this massaged
%data we can see 


%Fill in code here
subplot(2,1,1),dendrogram(linkage(squareform((perc_hum-min(perc_hum(:)))/100)), numel(data.labels))
xlabel('human!');
subplot(2,1,2),dendrogram(linkage(squareform((perc_monk-min(perc_monk(:)))/100)), numel(data.labels))
xlabel('monkey!');