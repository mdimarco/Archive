
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
T(1,2) = b;
T(m+1,m+1) = 1-d;
T(m+1,m) = d;

for t = 2:m
    T(t,t) = 1-b-d;
    T(t,t+1) = b;
    T(t,t-1) = d;
end
T = T';

% (a) Compute state probabilities after one transition
p0 = ones(m+1,1)/(m+1); % state probability at time 0
%TODO: Use T and p0 to compute probabilities after one step
p1 = T*p0;
p_first = p1;

% (b-c) Compute state probabilities after 100 transitions (time steps)
%p0 = ones(m+1,1)/(m+1); % (b) uniform initial state probability 
p0 = [1; zeros(m,1)]; % (c) initial state has empty queue

epsilon = zeros(Nmax,1); % Absolute change in state probabilities

p_curr = p0;
for t = 1:Nmax
  %TODO: Compute probability of states at time t
  %TODO: Compute epsilon(t)
  p_next = T*p_curr;
  epsilon(t) = sum(abs(p_next-p_curr));
  p_curr = p_next;
end

figure(1);
plot([1:Nmax],epsilon,'-k','linewidth',2);

% (d) Approximate state probabilities via Monte Carlo
Nmc = 1000;
probMC = zeros(m+1,1);  % Replace with Monte Carlo estimates of probabilities

for i = 1:Nmc
  %TODO: Simulate Markov chain for Nmax time steps,
  %      and count frequencies of final states to define probMC
    pos = 1;
    for t=1:Nmax
        move = randsample('bds',1,true,[b,d,1-b-d]);
        if (move == 'b') && (pos ~= m+1)
            pos = pos + 1;
        end
        if (move == 'd') && (pos ~= 1)
            pos = pos - 1;
        end
    end
    probMC(pos) = probMC(pos) + 1;
end
probMC = probMC./Nmc;
p1 = p_curr;
figure(2);
delta = abs(probMC - p1)./p1;
plot([0:m],delta,'-k','linewidth',2);



