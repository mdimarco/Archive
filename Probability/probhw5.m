
%%
%% Brown CS145 HW5: Gaussian Naive Bayes Ozone Level Classification
%%

% VARIABLES IN 'ozone.mat'
% trainFeat: Ntrain x M matrix of real-valued environmental features 
% trainLabels: Ntrain x 1 vector of class labels, 1=ozone-day, 0=not-ozone-day
% testFeat:  Ntest x M matrix of real-valued environmental features
% testLabels:  Ntest x 1 vector of class labels, 1=ozone-day, 0=not-ozone-day
% More info: http://archive.ics.uci.edu/ml/datasets/Ozone+Level+Detection

% NOTE: Because Matlab indexes vectors and matrices starting with 1,
% we use row 1 to store information about class 0 (not-ozone-day),
% and row 2 to store information about class 1 (ozone-day)

% Load data
clear all;
load('data/ozone');
numTrain = size(trainFeat, 1);
M = size(trainFeat, 2);

% Possible models: Uncomment line corresponding to part being worked on
%learnPrior = false; learnVar = false; % (b) pY=0.5, variances=1
%learnPrior = false; learnVar = true;  % (c) pY=0.5, variances estimated
learnPrior = true;  learnVar = true;  % (d) pY estimated, variances estimated

% Split training data into two separate classes
trainFeat0 = trainFeat((trainLabels==0),:);
trainFeat1 = trainFeat((trainLabels==1),:);

% Estimate p_Y(y) from training data, or set to be symmetric
% pY(1) equals P(Y_i=0)
% pY(2) equals P(Y_i=1)
if learnPrior
  % (d) Estimate class probabilities by frequencies in trainLabels
  pY(1) = size(trainFeat0,1)/numTrain;
  pY(2) = size(trainFeat1,1)/numTrain;
else
  pY(1) = 0.5;
  pY(2) = 0.5;
end

% Estimate mean of Gaussian f_X|Y(x_ij | y_i) 
% muhat(1,j) equals the mean of X_ij given Y_i=0
% muhat(2,j) equals the mean of X_ij given Y_i=1
muhat = zeros(2,M);
muhat(1,:) = mean(trainFeat0);
muhat(2,:) = mean(trainFeat1);

% Estimate variance of Gaussian f_X|Y(x_ij | y_i) 
% sigsqhat(1,j) equals the variance of X_ij given Y_i=0
% sigsqhat(2,j) equals the variance of X_ij given Y_i=1
if learnVar
  % (c) Estimate variances from empirical distribution of trainFeat
  sigsqhat(1,:) = var(trainFeat0,1);  
  sigsqhat(2,:) = var(trainFeat1,1);
else
  sigsqhat = ones(2,M);
end

% Calculate unnormalized log posterior probability of each class
% logPost(i,1) equals log(P(Y_i=0)) + log(f(X_i | Y_i=0))
% logPost(i,2) equals log(P(Y_i=1)) + log(f(X_i | Y_i=1))
numTest = length(testLabels);
logPost = zeros(numTest, 2);
for i=1:numTest
  % (b) Compute log-probabilities needed for Bayesian classification
  %[function of testFeat(i,:), muhat(1,:), sigsqhat(1,:)]
  
% Showing work:
%   exp_top = (testFeat(i,:)-muhat(1,:)).^2;
%   exp_bottom = 2*sigsqhat(1,:);
%   exp_log = -1*exp_top./exp_bottom;
% 
%   outer_top = 1;
%   outer_bottom = sqrt( 2*pi*sigsqhat(1,:));
%   outer_log = log( outer_top./outer_bottom );
%   
%   gaus_log = outer_log+exp_log;
%   
%   logPost(i,1) = log(pY(1)) + sum(gaus_log);
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   exp_top2 = (testFeat(i,:)-muhat(2,:)).^2;
%   exp_bottom2 = 2*sigsqhat(2,:);
%   exp_log2 = -1*exp_top2./exp_bottom2;
% 
%   outer_top2 = 1;
%   outer_bottom2 = sqrt( 2*pi*sigsqhat(2,:));
%   outer_log2 = log( outer_top2./outer_bottom2 );
%   
%   gaus_log2 = outer_log2+exp_log2;
%   
%   logPost(i,2) = log(pY(1)) + sum(gaus_log2);
  
%Two Liner:
  logPost(i,1) =  log(pY(1)) + sum( log(1./sqrt(2*pi*sigsqhat(1,:))) - ((testFeat(i,:) - muhat(1,:)).^2)./(2*sigsqhat(1,:)) ); %[function of testFeat(i,:), muhat(1,:), sigsqhat(1,:)]
  logPost(i,2) =  log(pY(2)) + sum( log(1./sqrt(2*pi*sigsqhat(2,:))) - ((testFeat(i,:) - muhat(2,:)).^2)./(2*sigsqhat(2,:)) ); %[function of testFeat(i,:), muhat(2,:), sigsqhat(2,:)]
end

% Determine estimated class label yHat(i) for each test example i
[maxlogPost, argmaxY] = max(logPost, [], 2); 
yHat = argmaxY - 1;

%Accuracy (fraction of test days classified correctly)
accuracy = sum(yHat==testLabels)/numTest;
display(['Test accuracy is ',num2str(accuracy)]);
