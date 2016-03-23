%% Bayesian Inference
%Mason DiMarco (mdimarco)


%% 1. Probability
%%
% _This pre-lab is adapted from a problem set devised and generously
% provided by Tom Griffiths_
%%
% Suppose you found a coin and wanted to know whether it was fair or
% biased. Let ? denote the probability that the coin produces heads each
% time you flip it, and assume that successive flips are independent. You
% have two hypotheses: h0 is the hypothesis that the coin is fair, with
% ? = 0.5; h1 is the hypothesis that the coin is biased, with ? = 0.9. A
% priori, you consider these hypotheses equally likely, so
% p(h0) = p(h1) = 0.5
%%
% Imagine you flip the coin once and it produces heads. Let d denote these
% data. What is the likelihood of these data under h0 and h1 [i.e. what is
% p(d|h0) and p(d|h1)]? Use Bayes rule to compute the posterior probability
% of h1. First work it out by hand.

%%
% Now write a script that computes the answer. Check the results you
% obtained by hand with the output of your script.
 


pH0 = 0.5;
pH1 = 0.5;
phH0 = 0.5;
phH1 = 0.9;
ph = pH0*phH0+pH1*phH1;

%Probability of hypothesis 1 being true given heads
pH1h = phH1*pH1/ph;
pH0h = 1-pH1h; %probability of the other hypothesis being true(1-ph1 since there are only 2 hypothesis)
%%
% Now, imagine you flipped the coin N times and produced a sequence
% containing Nh heads. For instance, imagine we flipped a coin 10 times and
% got 6 heads. What is the likelihood of this outcome under h0 and h1?

% Your code goes here.
n=10;
k=6;
pkheadsH0 = nchoosek(n,k)*phH0^k*(1-phH0)^(n-k);
pkheadsH1 = nchoosek(n,k)*phH1^k*(1-phH1)^(n-k);
pkheads = pkheadsH0*pH0+pkheadsH1*pH1;

%Probability of H1,H0 respectively, given k heads out of n flips
pH1kheads = pkheadsH1*pH1/pkheads;
pH0kheads = pkheadsH0*pH0/pkheads;

%%
% Generalize your script into a function that takes the number of heads and
% the number of tails in a sequence as inputs and returns the posterior
% probability of h1. 
 
% Your code goes here.
%Done as an input/output above,

%INPUTS
num_heads = 6;
num_tails = 4;

%BEGIN FUNCTION

n=num_heads+num_tails;
k=num_heads;
pkheadsH0 = nchoosek(n,k)*phH0^k*(1-phH0)^(n-k);
pkheadsH1 = nchoosek(n,k)*phH1^k*(1-phH1)^(n-k);
pkheads = pkheadsH0*pH0+pkheadsH1*pH1;
%Probability of H1, given k heads out of n flips
pH1kheads = pkheadsH1*pH1/pkheads;
%END FUNCTION

%RETURN
post_h1 = pH1kheads

%%
% Now plot this posterior probability for sequences with N = Nh ranging
% from 1 to 10 (from one to ten heads in a row). Describe what happens and
% explain intuitively why this is the case.
 
% Your code goes here.


N = 10;
trials = 1:N;
postH0 = zeros(N,1);
postH1 = zeros(N,1);
for n=1:N
    pkheadsH0 = nchoosek(N,n)*phH0^k*(1-phH0)^(N-n);
    pkheadsH1 = nchoosek(N,n)*phH1^k*(1-phH1)^(N-n);
    pkheads = pkheadsH0*pH0+pkheadsH1*pH1;

    %Probability of H1,H0 respectively, given k heads out of n flips
    pH1kheads = pkheadsH1*pH1/pkheads;
    pH0kheads = pkheadsH0*pH0/pkheads;
    
    postH0(n) = pH0kheads;
    postH1(n) = pH1kheads;
end

scatter(trials,postH0);
hold on
scatter(trials,postH1);

%As the number of heads increases, the probability of a biased coin (H1)
%increases. This makes sense, as if we see 9 heads come out of 10, it looks
%very consistent with the ideas that a biased coin of .9 chance of getting
%a heads is being flipped.

%% 2. The number game
%%
% _This lab is adapted from a problem set devised and generously
% provided by Josh Tenenbaum_
%%
% Josh Tenenbaum (2000) presented participants with a version of the
% following game: An experimenter tells you a set of numbers (for instance,
% 10, 20 and 50) between 1 and 100 that are members of a certain concept
% that he/she has in mind. You tell the experimenter your belief that
% another given number is part of the concept. Intuitively, most of us
% judge 40 to be much more likely than 37, because the "rule of the game"
% seems likely to be the concept "multiples of ten." In this lab, you
% will write a program that plays the number game.
%%
% Mathematically, we will make the assumption that the experimenter chooses
% a concept and then randomly generates numbers between 1 and 100 from that
% concept. The concept specifies a set S. So, for instance, if he/she
% chooses the concept "all multiples of 20," then the set is 20, 40, 60,
% 80, 100. She is then equally likely to say any given number from this
% set. We will assume that this happens "with replacement": she is allowed
% to say the same number multiple times (e.g., "20, 20, 40" is allowed).
%%
% The probability that a given number is in the set is just the sum over all
% possible concepts, multiplied by how likely the concept is a priori, and
% how well the concept fits the data that we have been given so far.
%%
% Remember that the probability of a series of independently generated data
% points is just the probability of each one multiplied together.
%%
% We will write a program that will take a set of numbers as input and
% output a plot of the probability, for each number between 1 and 100, that
% the given number is in the set the experimenter has in mind. Luckily,
% Josh shared his code with us so we won't have to code this from scratch.
% But we will have to fill in some code.
%%
% Start by opening the file *number_game_likelihood.m* and filling in the
% required code. This function should return the log likelihood of the data
% given a hypothesis, or log[Pr(D|H)]. Using logarithms is common in
% problems like these since we often need to compare very small numbers.
% Two small numbers can each get accidentally rounded to zero in the
% computer's memory (this is called "underflow error") while the logs of
% two very small numbers are just very negative and are thus easier to work
% with. Recall that adding the logarithms of two numbers is just like
% multiplying them together. You'll need to write code that assigns
% log_likelihood with a value and then save the function. The rest of
% Josh's code will take care of things like the sum and the priors.
%%
% If done properly your code will implicitly instantiate the size principle:
% Hypotheses which make very specific predictions (small sets, in this
% case) are given a big boost when those predictions come true, while
% hypotheses that make very general predictions (large sets) are given only
% a small boost. For instance, "20, 40, 60" boosts the likelihood of the
% hypothesis "multiples of 10" more than the hypothesis "even numbers."
% Remember that you do not need to do anything extra to capture the size
% principle. Doing the math properly will capture it for free.
%%
% Now take a look at the script *numbergame.m* This script creates a simple
% hypothesis space, and then plots the probability that each given number
% from 1 to 100 is in the set, given some data. A hypothesis is just a
% column vector, where the nth entry is 1 if the number is in the set
% specified by the hypothesis and zero otherwise. The script has been set
% so that it initially only considers hypotheses of the form "multiples of
% x," where x is a number from 1 to 100. We'll expand on this hypothesis
% space below. This script will call your log_likelihood function, so make
% that is working before you try. Try out the following data sets on this
% program:
 
%[50]
%[7]
%[90 70 30]
%[21 91 11]
%[64 32 16]
%[2 4 6 8]
%[1 3 5 7 9]
%[5 23 77 91]
%[2 73 17 47 11]
%[51 52 57 58]
%[1 2 3 5 8]
%[4 8 15 16 23]
%%
% Note: Some of these won't work very well in your program -- we'll change
% this soon.
%%
% Try running this program with no data at all (data = []). What do you
% find? What are we displaying when we do this? *Make sure you answer this
% question in the take-home portion.* Extra Credit: Some numbers have a
% very low probability in this graph. What set do they belong to?

%With empty data, we're displaying all possible hypothesis that could
%happen, if we only had even and odd numbers as our hypothesis, we would
%just see a straight bar graph of all numbers because each would be equally
%likely to occur according to our model.

%We see that there are some numbers that just don't belong to that many
%hypothesis. If I had many hypothesis with the number 60, for instance,
%the number 60 would be a higher probability of being found given [] data.


%% 3. Adding more hypotheses and real computational cognitive science
%%
% You'll notice that the program doesn't do very well with the example
% [1 3 5 7 9]. To make it work better on this problem, let's give it a
% hypothesis that represents "odd numbers." We can add a hypothesis using
% the following code:
 
%     hypload=zeros(N,1);
%     for j=1:N
%         if mod(j,2)==1
%             hypload(j)=1;
%         end
%     endhyps = [hyps hypload];
%%
% What does this program think about the number 37, now that is has "odd
% numbers" as a hypothesis? What does the program do when you remove this
% hypothesis?

%We see a all odd numbers having a small probability when the odd numbers
%are in there because of this new hypothesis, but when it's taken out their
%probability is 0.
%%
% Use the above code as a template for adding new hypotheses (The code has
% been set up so that you can append an arbitrary number of hypotheses this
% way -- each will be assigned equal prior probability). The first thing to
% do is to add intervals to your hypothesis space: for instance, all numbers
% between 50 and 60, or all numbers between 75 and 100. Beyond this, try to
% construct a hypothesis space that captures your own intuitions about he
% number game. Don't worry if you don't have strong intuitions about one or
% two of the sets of numbers in the example data we provide above - some
% may be random. Describe the hypotheses you added. How, if at all, did
% changing the hypothesis space change the output of the program? What does
% this tell us about how learning new concepts can change our ability to
% make predictions about the real world? Can you give at least one example?

%Changing the hypothesis space to add in ranges 45-55 and 50-60 gives two
%more hypothesis containing these numbers. Now testing with the data 50-55
%we see that the numbers 50-55 will definitely be in the number game, but
%that 45-50 and 55-60 will be equally likely, because of these two
%hypothesis.

%%
% Now you will actually model data that you collect yourself - this is real
% computational cognitive science! Give at least three friends the data sets
% from question 2 and ask them to list some candidate numbers that come
% quickly to mind as other members of the set. (You don't need to ask them
% for the probability of each and e% Now you will actually model data that you collect yourself - this is real
% computational cognitive science! Give at least three friends the data sets
% from question 2 and ask them to list some candidate numbers that come
% quickly to mind as other members of the set. (You don't need to ask them
% for the probability of each and every number from 1 to 100). Compare your
% data to the output of your program. If you've modeled the data well, then
% the numbers that come to mind first should correspond to the numbers
% assigned high probability by your model. When (and if) there is a
% disparity, try to add concepts to your hypothesis space that attempt to
% bridge the gap. Describe the results of your survey and what changes you
% made. You don't need to model the data perfectly - just try to move in
% the right direction. For extra credit, try changing not just the
% hypotheses, but the way that prior probabilities are assigned, in order
% to fit human data better. For even more extra credit, try a generative
% approach: Assign priors to hypotheses based on rules that make rules.
%%
% After changing your hypothesis space, test the predictions of your new
% model. For instance, imagine people kept saying"80" when you gave them
% [24 72]. You might say that this is because there is a concept "years in
% the 20th century in which a Republican was elected president of the
% United States." You should now test your model on new predictions - for
% instance when you say [52 20], people should say "88," but not "48."
% (This prediction probably wouldn't hold up.) Come up with three new sets
% (hopefully better ones!) for your revised model and test them on three
% more friends. Report your results. It's okay if your results disconfirm
% your model. The process of testing is the important part. Compare your
% data to the output of your program. If you've modeled the data well, then
% the numbers that come to mind first should correspond to the numbers
% assigned high probability by your model. When (and if) there is a
% disparity, try to add concepts to your hypothesis space that attempt to
% bridge the gap. Describe the results of your survey and what changes you
% made. You don't need to model the data perfectly - just try to move in
% the right direction. For extra credit, try changing not just the
% hypotheses, but the way that prior probabilities are assigned, in order
% to fit human data better. For even more extra credit, try a generative
% approach: Assign priors to hypotheses based on rules that make rules.

% It seemed in my tests that people have a more simple subset in mind.
% Giving the numbers [24 72] generally yielded 96 (the addition of the
% two), not 80, perhaps because people look for simpler patterns in smaller
% amounts of numbers than searching for something more specific. A longer
% list given, however, such as [2, 3, 5, 7, 11 ] would yield 13 or 17, as
% user's seemed more likely to look for "deeper" patterns when there were
% longer strings of numbers. 
%
% If I were to create priors or change the probabilities. I would probably
% create a weighting of hypothesis based on a few assumptions. I would
% give hypothesis such as evens, or odds a very high weight, and something
% such as "republican presidencies" lower weights. If this showed not to be
% enough, I may just crowd-source this for my prior, creating a true
% prior based on a population's sample responses. 



















