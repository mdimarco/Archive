
%%
%% Brown CS145 HW9: Birth-Death printer queue
%%

close all; 
clear all;

% Constants defining birth-death queue
m = 9;
b = 0.2;
d = 0.5;

% Number of time steps of Markov chain
Nmax = 100;

% (a) Construct state transition matrix T
T = zeros(m+1, m+1);
%TODO: Fill entries of T.  Each column should sum to 1.
T(1,1) = 1-b;
T(10,10) = 1-d;
T([2:9],[2:9]) = 1-b-d;
T([1:9],[2:10]) = b;
T([2:10],[1:9]) = d;

% (a) Compute state probabilities after one transition
p0 = ones(m+1,1)/(m+1); % state probability at time 0
%TODO: Use T and p0 to compute probabilities after one step

% (b-c) Compute state probabilities after 100 transitions (time steps)
%p0 = ones(m+1,1)/(m+1); % (b) uniform initial state probability 
p0 = [1; zeros(m,1)]; % (c) initial state has empty queue

epsilon = zeros(Nmax,1); % Absolute change in state probabilities

for t = 1:Nmax
  %TODO: Compute probability of states at time t
  %TODO: Compute epsilon(t)
end

figure(1);
plot([1:Nmax],epsilon,'-k','linewidth',2);

% (d) Approximate state probabilities via Monte Carlo
Nmc = 1000;
probMC = zeros(m+1,1);  % Replace with Monte Carlo estimates of probabilities

for i = 1:Nmc
  %TODO: Simulate Markov chain for Nmax time steps,
  %      and count frequencies of final states to define probMC
end

figure(2);
delta = abs(probMC - p1)./p1;
plot([0:m],delta,'-k','linewidth',2);
