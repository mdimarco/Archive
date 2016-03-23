
%%
%% Brown CS145 HW7: Automobile MPG prediction using Gaussian regression
%%

% VARIABLES IN 'auto-mpg.mat'
% weight_train: vector of training data for weight 
% weight_test:  vector of test data for weight 
% horsepower_train: vector of training data for horsepower 
% horsepower_test : vector of test data for horsepower 
% mpg_train: vector of training data for mpg 
% mpg_test : vector of test data for mpg 

% Load data
close all;
clear all;
load('auto-mpg');
Ntrain = length(horsepower_train);
Ntest  = length(horsepower_test);

% Possible experiments: Uncomment line corresponding to part being worked on
%useWeight = true;  thresh = 0; % (b) X=weight, single Gaussian
%useWeight = false; thresh = 0; % (c) X=mpg, single Gaussian
useWeight = false; thresh = 20; % (d) X=mpg, two Gaussians

% Define selected training and test data
if useWeight
  Xtrain = weight_train;
  Xtest  = weight_test;
  Xlabel = 'Weight';
  Ytrain = horsepower_train;
  Ytest  = horsepower_test;
else
  Xtrain = mpg_train;
  Xtest  = mpg_test;
  Xlabel = 'MPG';
  Ytrain = horsepower_train;
  Ytest  = horsepower_test;
end

% Plot selected training data
figure(1);
plot(Xtrain, Ytrain, 'ok'); hold on;
xlabel(Xlabel); ylabel('Horsepower'); title('Training Data');

% Fit single Gaussian model if thresh==0
if (thresh == 0)

  % Predict Ytest given Xtest, and model learned from (Ytrain,Xtrain)
  % TODO: Extend pred_linear.m to compute correct Ypred values
  [Ypred, mu, sigma] = pred_linear(Xtrain, Ytrain, Xtest);
  
  % Plot model learned from training data
  plot_contour(Xtrain, Ytrain, mu, sigma, 500);
  
  % Compute error on test data
  squared_error = sqrt((1/Ntest) * sum((Ypred - Ytest).^2));
  fprintf('Average test error: %.4f\n', squared_error);
  
  % Plot Ypred versus Ytest
  figure(2); 
  plot(Xtest, Ytest, 'ok', Xtest, Ypred, '*r');
  xlabel(Xlabel); ylabel('Horsepower');
  legend('Ground truth test data', 'Predicted test data');
  title('Test Data');

% Otherwise fit two separate models for data above and below thresh
else

  % Split training and test data based on thresh
  Xtrain_1 = Xtrain(Xtrain <= thresh);
  Xtrain_2 = Xtrain(Xtrain > thresh);
  Ytrain_1 = Ytrain(Xtrain <= thresh);
  Ytrain_2 = Ytrain(Xtrain > thresh);
  Xtest_1 = Xtest(Xtest <= thresh);
  Xtest_2 = Xtest(Xtest > thresh);
  Ytest_1 = Ytest(Xtest <= thresh);
  Ytest_2 = Ytest(Xtest > thresh);

  % Separately build models and predict test data above and below thresh
  % TODO: Estimate Ypred_1 from Xtrain_1, Ytrain_1, Xtest_1
  % TODO: Estimate Ypred_2 from Xtrain_2, Ytrain_2, Xtest_2
  [Ypred_1, mu_1, sigma_1] = pred_linear(Xtrain_1, Ytrain_1, Xtest_1);
  [Ypred_2, mu_2, sigma_2] = pred_linear(Xtrain_2, Ytrain_2, Xtest_2);
  
  
  % Plot model learned from training data
  plot_contour(Xtrain_1, Ytrain_1, mu_1, sigma_1, 500);
  plot_contour(Xtrain_2, Ytrain_2, mu_2, sigma_2, 500);
  
  
  % Compute error on test data
  squared_error = sqrt((1/Ntest) * ...
    (sum((Ypred_2 - Ytest_2).^2) + sum((Ypred_1 - Ytest_1).^2)));
  fprintf('Average test error: %.4f\n', squared_error);

  % Plot Ypred versus Ytest
  figure(2);
  plot(Xtest, Ytest, 'ok', Xtest_1, Ypred_1, '*r', Xtest_2, Ypred_2, '*b');
  xlabel(Xlabel); ylabel('Horsepower');
  legend('Ground truth test data', 'Predicted test data');
  title('Test Data');

end

