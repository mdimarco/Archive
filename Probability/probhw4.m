
%%
%% Brown CS145 HW4: Old Faithful Geyser Data Statistics
%% Mason DiMarco

% Description of data:
%   Waiting time between eruptions and the duration of the eruption
%   for the Old Faithful geyser in Yellowstone National Park, Wyoming, USA.
%
% eruptions (numeric)  Eruption time in mins
% waiting   (numeric)  Waiting time to next eruption in minutes
% 
% References:
% - Hardle, W. (1991) Smoothing Techniques with Implementation in S.
%   New York: Springer.
% - Azzalini, A. and Bowman, A. W. (1990). A look at some data on the
%   Old Faithful geyser. Applied Statistics 39, 357-365.

% Load data 
clear all;
load geyser;
S = eruptions;  % vector of observed eruption times
T = waiting;    % vector of observed waiting times
n = length(S);  % number of observations

% Plot data
figure(1);
plot(S,T,'ok','linewidth',2);
xlabel('Eruption Time (minutes)');
ylabel('Waiting Time to Next Eruption (minutes)');

% Compute mean under empirical distribution
meanS = sum(S)/n;
meanT = sum(T)/n;

% (a) Compute Var[S] and Var[T] under empirical distribution
varS = S'*S/n - meanS^2;
varT = T'*T/n - meanT^2;

% (b) Compute Cov[S,T] under empirical distribution
covST = S'*T/n - (sum(S)/n)*(sum(T)/n);

% (c) Compute cumulative distributions and find target values
ordered_s = sort(S);
s_q1 = ordered_s(n/4);
s_q2 = ordered_s(n/2);
s_q3 = ordered_s(3*n/4);

ordered_t = sort(T);
t_q1 = ordered_t(n/4);
t_q2 = ordered_t(n/2);
t_q3 = ordered_t(3*n/4);

%And to plot it
% ecdf(S)
% ecdf(T)

% (d) Determine joint and marginal distributions of X,Y
indX = find(ordered_s>3.5,1);
pX0 = indX/n;
pX1 = (n-indX)/n;

indT = find(ordered_t>70,1);
pT0 = indT/n;
pT1 = (n-indT)/n;

%joint distribution, find the occurances of both x and y happening and
%their respective probabilities (the intersection of occurences for X = 0,1
%and Y = 0,1)


x0_and_t0 = sum((ordered_s <= 3.5) & (ordered_t <= 70))/n;
x0_and_t1 = sum((ordered_s <= 3.5) & (ordered_t > 70))/n;
x1_and_t0 = sum((ordered_s > 3.5) & (ordered_t <= 70))/n;
x1_and_t1 = sum((ordered_s > 3.5) & (ordered_t > 70))/n;

joint_pmf = [ x0_and_t0 x0_and_t1; x1_and_t0 x1_and_t1];

%marginal
%summing over t variable to get the marginal of x
marg_x = sum(joint_pmf,2);
%summing over x variable to get the marginal of t
marg_t = sum(joint_pmf,1);

% (e) Check conditions for independence of X and Y
threshX = 3.5;
threshY = 70;

%If they are independant, p(x,y) for all x,y in the
%joint distribution should be equal to px(x)*py(y)
mult_xy = [ pX0*pT0 pX0*pT1; pX1*pT0 pX1*pT1];

mult_xy
joint_pmf

%These variables look very dependant, which seems logical given their
%correlation. It seems far more likely that you will see the geyser go off
%for a longer amount of time given you have waited a long time for it.
