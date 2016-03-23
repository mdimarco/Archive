function [y_pred, mu, sigma] = pred_linear(x_train, y_train, x_test)
%[y_pred, mu, sigma] = pred_linear(x_train, y_train, x_test)
%   Fit a Gaussian model to training data, and predict y given x_test 
% Inputs:
%   x_train: N*1 vector
%   y_train: N*1 vector
%   x_test:  M*1 vector
% 
% Outputs:
%   y_pred:  M*1 vector
%   mu: 1*2 mean vector
%   sigma: 2*2 symmetric covariance matrix

% Mean of training data
% mu(1) = E[X]
% mu(2) = E[Y]
mu = mean([x_train y_train]);

% Covariance of training data
% sigma(1,1) = Var[X]
% sigma(2,2) = Var[Y]
% sigma(1,2) = sigma(2,1) = Cov[X,Y]
sigma = cov(x_train, y_train, 1);

% Predict y_test as conditional mean given x_test, under Gaussian model
% y_pred(i) = E[Y | X=x_test(i)]

sdx = sqrt(sigma(1,1));
sdy = sqrt(sigma(2,2));
rho = sigma(1,2)/(sdx*sdy);

y_pred = mu(2)*ones(size(x_test))+(rho*sdy/sdx)*(x_test-mu(1));
%TODO:  Improve prediction formula to account for observations x_test

