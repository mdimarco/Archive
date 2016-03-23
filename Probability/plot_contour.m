function plot_contour(x_train, y_train, mu, sigma, n_steps)

x_steps = ((max(x_train) - min(x_train))/n_steps);
y_steps = ((max(y_train) - min(y_train))/n_steps);
x = min(x_train)-x_steps*100:x_steps:max(x_train)+x_steps*100;
y = min(y_train)-y_steps*100:y_steps:max(y_train)+y_steps*100;

[X, Y] = meshgrid(x, y);
inv_sigma = inv(sigma);
Z = 1/sqrt(2*pi)/sqrt(det(sigma)) * exp(-1/2 * ...
    ((X -mu(1)).^2.*inv_sigma(1,1) + ...
    (Y - mu(2)).^2.*inv_sigma(2,2) + ...
    (X-mu(1)).*(Y-mu(2)).*2*inv_sigma(1,2)));

contour(X, Y, Z);

end

