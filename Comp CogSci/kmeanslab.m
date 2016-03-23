%% Clustering and Learning Prototypes

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% !!! Resources to work on this module can be found in this zip file: !!!
% !!! https://canvas.brown.edu/courses/957516/files/47421000/download !!!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%% 1. K-Means Clustering (preparation)
%
% Use file "Module 5 - Prep.pdf" from the resources.zip file (link above)
% for this part of the assignment.
%
% Let's consider a 2D dataset along with potential random initialization
% centroids as shown in the figure. If the k-means algorithm starts with
% these centroids, where will it end up? For each condition, annotate by
% hand what you think will be stable solutions of the algorithm. Your
% answer should include an outline surrounding each cluster as well as the
% final centroids of each. Remember some of the things we discussed during
% class that can influence the result of k-means (density of points in each
% cluster, local maxima, initilization, etc).
%
% Modify the figure in the drawing software of your choice and turn in that
% document.
%
%%
%
% In addition to the above assignment, please read the directions for the
% lab prior to the day of the lab. There is a lot of information for this
% one!

%% 2. Authorship Attribution 
%
% _The work behind this assignment is based on the research of Neal Fox, a
% CLPS doctoral student who studies linguistics and authorship
% attribution._
%%
%
% In this lab, you will apply your knowledge about k-means clustering to a
% current research problem: discovering groupings of documents according to
% the identity of their author. The directions will walk you through the
% problem and the approach used - don't be overwhelmed by the amount of
% background information involved! Most of the questions at the end simply
% ask you to change some parameters, see what the results are, and think
% about the results intuitively.
%
%%
% *Background: How the model of authorship attribution works*
%
%%
%
% When we don't know who the author of a document is, how can we make
% predictions about their identity, or find other documents that are also
% likely to be by this same unknown person? This is a longstanding question
% in computational linguistics and work on this question is currently
% informing research on the Bible, Shakespeare, plagiarism detection, and
% forensic science, just to name a few areas. For example, you can probably
% tell whether your mother or your father wrote an email to you, even if
% you don't know which email address it came from. You might imagine that
% we are tracking some simple word statistics that characterize their
% speaking/writing style (your mom uses the word _nevertheless_ in the same
% places your father might use the word _however_). In this lab, you will
% think about how we recruit our implicit knowledge of the statistics
% underlying their respective "styles" in order to identify them while
% reading that email.
%%
%
% The models we are going to implement rely on the assumption that the
% statistics you're tracking during your interactions with mom or dad are
% about lexical frequency (how often different words appear). Examining a
% corpus of texts by different authors, we will first look at the relative
% frequencies of all words in the corpus and see how predictive of
% authorship they are. Then, we will look at another model using
% frequencies of a very specific class of words that we call
% _topic-independent words._ Linguists might call them _function words_ and
% computer scientists often refer to them as _stop words_, but the key is
% that they are words that are distributed fairly consistently across
% documents about all different topics; they primarily carry grammatical
% information, but not much content. Some examples are _the_, _and_, _of_,
% and _respectively_. We will try to find out how informative each of these
% two measures is as we try to group documents based on authorship.
%%
%
% The statistics that a model is making use of (tracking) are called the
% _features_ of that model. In the corpus you will examine (with a total of
% 49,197 words), there are 11,180 *different* words. Every document can
% thus be represented as a vector that has 11,180 entries in it. Some words
% will never appear in that document, so the entry for that feature will be
% 0, and the entry for every other word that does appear in the document
% will be equal to the relative frequency of that word in the document (that
% is, the # of times that word occurs in the document/the total # of words
% in the document). In the topic-independent feature list (Fox, Ehmoda &
% Charniak, 2011), there are only 476 words, so each document can be
% represented by a much shorter (476-dimensional) column vector. If each
% document is represented by a vector, you can think of documents as points
% in a very high dimensional space. Documents that are close together in
% that space contain similar words in similar frequencies. The critical
% assumption underlying computational models of authorship attribution is
% that whatever features a model is using, documents by a single author
% tend to be relatively consistent in those words' frequencies, so
% clustering points in the high-dimensional space is just like trying to
% find the groupings of documents that tend to center around some set of
% average distributions which represent each author.
%%
% You will test how well k-means clustering does at grouping together
% documents by the same author.
%%
% *The data and provided MATLAB scripts are available at the top of this script*
%%
%
% 1. 72 movie reviews were downloaded from sources such as "Yahoo! Movies."
% This movie review corpus has the unique trait of being "fully crossed"
% with respect to "movie reviewed" and "movie reviewer": 6 reviewers
% reviewed each of 12 movies. For example, there are six reviews of "The
% Social Network," one by each author in the corpus.
%%
% Two variables were created from this data set:
%%
% a) *true_authors* is the true mapping of documents 1-72 to each document's
% author.
%%
% b) *true_movies* is the true mapping of documents 1-72 to each document's
% topic -- that is, the mapping from a document to which movie the document
% was a review of.
%%
% 2.*prob_docsT* is the full dataset, where each document is represented by
% its count for each of the 11,180 different words that exist in the corpus
% (that is, every word that appears at least once in the corpus). It
% contains a 72 x 11,180 matrix: each row is a document, and each column is
% a feature.
%%
% 3. *TI_prob_docsT* is the full dataset, where each document is represented by
% its count for each of the 476 topic-independent words that exist in the
% corpus. It contains a 72 x 476 matrix: again, each row is a document and
% each column is a feature.
%%
% 4. *evaluateClusters* is a script that evaluates how "good" the clusters are
% in a quantitative way via a modified version of a measure known as
% normalized mutual information. *You do not need to understand how it is
% calculated or what exactly it means*; it is an estimate of how good one
% clustering is compared to another with respect to the true classes. A
% minimum accuracy score of 0 means that there is no overlap between the
% clusters and the true classes. A maximum accuracy score of 1 roughly
% means that there is perfect overlap between the clusters and the true
% classes.
%%
%
% _To use this script, you need to open the file, change some variable
% names as described in the script's comments, save the script, and then
% type "evaluateClusters" in the command window. This will print the
% adjusted normalized mutual information score for you._

%%
% To better understand how this measure works, run the script on
% *true_authors* and *true_movies* to compare how well these two overlap.

%% 
% You will see that the adjusted normalized mutual information between the
% clusters is 0 - this is because of the fully crossed design.
%%
% Now run the script on *true_authors* and *true_authors*. 

%%
%
% As you might predict, you get a normalized information score of 1, since
% obviously these two clusterings overlap perfectly.
%%
%
% First, run the matlab k-means algorithm on the full dataset (prob_docsT)
% a few times with k = 6 (the number of authors there truly are).
%%
% _Hint: use *kmeans(prob_docsT,6)*_
%


load('resources/true_authors')
load('resources/prob_docsT')
load('resources/true_movies')

% Your code goes here.
docs = kmeans(prob_docsT,6);



%
% Take a look at the resulting label assignments and report a few of them
% using the command: *figure; bar(X)* where *X* is the output of the
% *kmeans()* command.
%

% Your code goes here.
figure; bar(docs)
%%
% Even though we are using the same *kmeans()* command with the same inputs
% each time, are the outputs consistently the same vector? Why or why not?
% *Explain why this might happen in the post-lab section*
%%
% Now change the k to 12 (the true number of movies). Run *kmeans()* once
% and report the output vector in the same way as when k = 6.
%

% Your code goes here.
docs = kmeans(prob_docsT,12);
figure; bar(docs)

%%
% Using the *evaluateClusters.m* script by editing and running it, find out
% how the clustering algorithm does at determining the best groupings of
% movies (compare true_movies to a k = 12 clustering) and of authors
% (compare true_authors to a k = 6 clustering).

%%
%
% *Describe your results in the post-lab and explain why one might be
% higher than the other*
%%
%
% _Hint: You don't need to know about how accuracy score is computed to get
% this. Think intuitively about what the features are and how they relate
% to movies or authors._
%%
%
% Now we will use the second model (topic-indepndent features) to group by
% author and by movie. Recall that this model is much smaller - there are
% fewer than 500 features in each vector rather than over 10,000. Note that
% the features themselves are quite different, though.
%%
%
% Use the k-means algorithm again to find the best clusters (try both k = 6
% (authors) and k = 12 (movies)), but this time use the data from
% *TI_prob_docT*.
%

% Your code goes here.

docs6 = kmeans(TI_prob_docsT,6);
docs12 = kmeans(TI_prob_docsT,12);
figure;bar(docs6)
figure;bar(docs12)


%%
%
% Now evaluate how well this model does at grouping documents: By author?
% By movie?


%Evaluate Clusters for prob_docsT
%By Movies (K=12) = .56
%By Authors (K=6) = .2


%Evaluate Clusters for TI_prob_docsT
%By Movies (K=12) = .32
%By Authors (K=6) = .3


%% 3. Finishing Up
%
% Which model (either *prob_docsT* or *TI_prob_docsT*) is better at each
% task? Explain why.

%Topic dependant words are better for classifying the movie reviews, which
%makes sense because that's a better identification scheme for them. A
%movie review would generally have a similar grammatical structure, but
%would vary by topic (e.g. the social network review may have the word
%"college" or "start-up" appear more in it)

%Topic independant words are better for classifying the authors. This makes
%sense because authors are going to write about many different topics, but
%may have distinct styles of how they use everyday words that could be
%identifiable. 

%Additionally, these results are not going to be the same because of the
%random initialization of centroids and the presence of local minima.
%Because k-means works on an energy function there are always local minima
%that the algorithm can get "stuck" at, and therefore by starting from
%different positions, different minima (with different evaluations) can be
%found.


%%
%
% Make sure you answer the questions we asked in the lab section!
%%
% *Extra Credit 1:* You can see differences in the models' evaluation
% scores, but they still aren't doing _that_ well - you can tell by looking
% at the results qualitatively. What would you do to improve? You can see
% the list of topic-independent words used as features in TI_prob_docsT
% <https://canvas.brown.edu/courses/851737/files/36009788/download? here.>
% Note that there are more words in the list than dimensions in
% *TI_prob_docsT* because some words never occurred in any document.

%Perhaps by lowering the amount of dimensions to our data by running PCA,
%we can obtain a faster way to compute our results while still running on
%the highest variance, and then begin a sequence of random restarts to
%increase our probability of finding the global minimum. 

%%
% *Extra Credit 2:* Obviously, when someone is doing authorship attribution
% on a set of documents, it is not always clear how many authors are
% represented in the set. There might be only 1 author who was very
% prolific, or there could be a different author for each document. Let's
% assume you do not know how many authors contributed to this set of 72
% documents, but you have a hunch based on some other information that it's
% somewhere between 2 and 30 authors. One of the strengths of the adjusted
% normalized mutual information score (the output of evaluateClusters) is
% that it can help you select the "best" value of k. The "best" value
% will be the one that yields the highest score, which means there is high
% overlap with the veridical classes of the documents (the true authors)
% and the results of the clustering, but also tries to keep k to a
% reasonable size (you don't want to have a single document in every
% cluster, because then your clusters are meaningless). Modify
% evaluateClusters.m to find the optimal k for the topic-independent model.
% Report your results and comment.

%Although I would expect the best values to be retured by k=6 given that
%there are 6 authors, I was actually able to get to 35% with k = 7, and on
%average the values returned by running on this number were higher. Perhaps
%there is one "hidden" cluster that is author-agnostic, such as word
%frequencies that are simply common among all authors in the set that don't
%particularly correspond to them.

%%
%
% In case you are curious, the source documents alongside with the script
% that generated the features are <https://canvas.brown.edu/courses/851737/files/36131389/download? here.>