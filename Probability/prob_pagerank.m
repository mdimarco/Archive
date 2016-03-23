
%%
%% Brown CS145 HW10: Markov chains and Pagerank
%% Code for parts (b-d).  Part (a) requires a separate solution.
%%

close all;
clear all;

% Data collected in 2002 by Prof. Jon Kleinberg, Cornell University
% Cleaned version courtesy of ECEN5322, University of Colorado
%   L(i,j)   = 1 if there is a directed link from website i to website j
%   L(i,j)   = 0 if there is no directed link from website i to website j
%   names{i} = URL of website i
load('large_network');
m = size(L,1);  % number of websites (nodes)

% (b) Compute random-walk state transition matrix T
T = zeros(m, m);
%TODO: Fill entries of T.  Each column should sum to 1.
tots = sum(L,2);
for i=1:m
    if tots(i) == 0
        T(i,i) = 1;
    else
        T(:,i) = L(i,:) ./ tots(i);
    end
end
% (b) Compute google matrix M (random-walk with teleportation)
alpha = 0.15;
%TODO: Fill entries of G.  Each column should sum to 1.
G = (1-alpha)*T + alpha*(1/m);
all_ones = sum(G); %all ones

% (c) Randomly surf the internet by following google matrix G for 100 time steps
p0 = ones(m, 1)/m;
n_iteration = 100;
epsilon = zeros(1, n_iteration);
for t = 1:n_iteration
  %TODO: Compute probability of states at time t;
  %TODO: Compute epsilon(t)
  p1 = G*p0;
  epsilon(t) = abs(sum(p1-p0));
  p0 = p1;
end

p_steady = p0; % TODO: Set p_steady to probability of states at n_iteration

plot(1:n_iteration, epsilon, 'k-', 'LineWidth', 2);

% (c) Display the highest ranked webpages
[rank_value, rank_inds] = sort(p_steady, 'descend');
fprintf('pagerank\t in\t out\t url\t alpha = %.2f:\n', alpha);
for i = 1:25
    cur_ind = rank_inds(i);
    links_in = sum(L(:, cur_ind));
    links_out = sum(L(cur_ind, :));
    fprintf('%.5f\t\t %d\t%d\t%s \n', rank_value(i), links_in, links_out,names{rank_inds(i)});
end