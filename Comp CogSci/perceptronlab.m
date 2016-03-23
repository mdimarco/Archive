%% Perceptrons
%mdimarco
%% 1. Introduction to the Neural Network toolbox
%%
% This week we will classify data with a perceptron. In the lab assignment
% we will use the MATLAB Neural Network toolbox, a built-in tool that will
% save you a lot of tedious coding. The goal of this prelab is to learn how
% to create a perceptron with the NN toolbox. You will then compare the
% output of your perceptron with one that has been hand-coded for you. 
%%
% The first thing we need is a dataset for binary classification. The
% following code generates a dataset that is linearly classifiable. You
% don't need to touch this code, but you'll need to know what it does in
% order to create your perceptron.

n   = 50;
dim = 2;

% Generate normally distributed data
sig = [.2 .2]; % width of the distribution
m   = [0 1];
% input vectors (n points for each class, dim dimensional)
X   = [m(1)+sig(1)*randn(n,dim); m(2)+sig(2)*randn(n,dim)];
Y   = [ones(n,1); -ones(n,1)]; % associated labels

% create independent test set
Xte = [m(1)+sig(1)*randn(n,dim); m(2)+sig(2)*randn(n,dim)];
Yte = [ones(n,1); -ones(n,1)]; % associated labels

scatter(X(:,1),X(:,2));


%%
% Now that you have an input and a test dataset, use the NN Toolbox to
% create a perceptron. There are two ways you can do this. The first is
% specific to the case of a linear perceptron:
%net = perceptron;
%net = configure(net,X,Y);
% where input arguments are as follows:
% P is an R-by-Q matrix of Q input vectors of R elements each.
% T is an S-by-Q matrix of Q target vectors of S elements each.

%%
% The second is more general:

 h = [];
 input = X;
 output = [Y Y];
 net = newff(input, output, h); 
 net = train(net, input, output);

%%
% You can use either method. But before creating a perceptron,
% take a look at the NN Toolbox documentation on the perceptron
% <http://www.mathworks.com/help/nnet/ug/perceptron-neural-networks.html#bss4hat-5 here.>
%%
% To see how a network performs, try typing: *sim(net, input);* This runs
% the network.
%%
% _Hint: Remember that the input and output dimensions must match! You
% might have to double the size of the labels for your data._

% Your code goes here
out = sim(net, Xte);

%%
% To evaluate your perceptron's ability to classify the data set, we have
% provided you with a hand coded perceptron you can compare your NN Toolbox
% perceptron to. You don't need to change this code, but make sure you run
% it! It will stop once it has appropriately classified the data. Let it
% run until it has finished.

figure(1);

% initialization
w    = randn(1,dim+1); % bias trick -- add an additional dimension
eta0 = .50; % learning rate
k    = 0;

ErrTr = []; % training error
ErrTe = []; % test error
close all;

while(1)
    ind = randperm(size(X,1)); % shuffle training data presentation order
    
    for i = ind
        k = k+1; % iteration number
        
        % try to change the learning rate and comment
        % on what happens when the learning rate is very small or
        % very large
        
        eta = eta0;
        % eta = eta0/(1+(k)); %% decreasing learning rate as a
        % function of the iteration #
        % Good idea! Why?
        
        y_i = Y(i);
        x_i = [1 X(i,:)]'; % bias trick contd!
        
        % looking at the current output of the perceptron
        z = w*x_i; % linear part of the response
        y = sign(w*x_i); % Heavyside function - convert to -1/1 values
        
        
        figure(1)
        
        % showing all datapoints (red for pos class and blue
        % for neg
        plot(X(1:n,1), X(1:n,2),'or', X(n+1:2*n,1), X(n+1:2*n,2),'pb');
        hold on;
        
        % show current datapoint in black
        plot(X(i,1), X(i,2),'sk', 'MarkerSize', 12);
        
        % show decision boundary before update
        % remember equation is: w(1) * 1 + w(2) a + w(3) b = 0
        % where a is abscissa and b ordinate
        a = [-2 2]; %% abscissa
        b = (-w(1)-a*w(2))/w(3);
        plot(a, b, 'm-');
        axis([-2 2 -2 2]); title(num2str(k))
        pause(.1)
        
        % stop if there is an error
        if (y_i~=y)
            disp('error');
            
            % make weight update (nothing will actually happen
            % unlesss the perceptron makes an error (ie, y_i-y ~=0)
            dw = eta*(y_i-y)*x_i';
            w  = w+dw;
            
            % show the update
            b = (-w(1)-a*w(2))/w(3);
            
            % showing the datapoints
            plot(a, b,'m--');
            axis([-2 2 -2 2]); title(num2str(k))
            pause(.1)
            
        end
        hold off;
        
        % evaluate error on training set
        Pred  = sign(w*[ones(size(X,1), 1) X]');
        Cor   = (Pred == Y');
        ErrTr = [ErrTr 1-mean(Cor)];
        
        figure(2);
        plot([1:length(ErrTr)], ErrTr, '--m');
        legend('Training error')
        
 
    end
    if ErrTr(k) == 0
        Pred = Pred';
        break;
    end
end

%%
% Once both of these perceptrons have been run, compare their respective
% outputs. Use the following code as a template (you'll need to replace the
% variable for your perceptron's output, leave the 'Pred' variable alone).

if Pred == out(:,1)
    disp('NN Toolbox perceptron classifies effectively.')
end
%% 2. Categorizing cats and dogs
%
% Now that you're familiar with the perceptron, we will apply it to
% model psychological data. Quinn et al. (1993) have shown that infants can
% learn to tell cats apart from dogs. We will see if a perceptron can do so
% as well. The provided data set *catsndogs* contains high level features
% of cats and dogs, taken from Mareschal et al. (2000). Each column
% represents an animal and each row represents a feature (or input
% dimension). For instance, the first row represents the 'head length' of
% each cat or dog and the third row represents the 'eye separation.' The
% features are normalized so that the maximum value of any given feature is
% 1.
load('resources/catsndogs')

%%
% First, teach a perceptron to tell the difference between cats and dogs
% using these data sets. This is very similar to what you did in the
% pre-lab assignment, but you'll need to provide the labels for the data.
% The same perceptron should be passed both the cats and dogs data.

% Your code goes here
cat_lab = ones(10,18);
dog_lab = -ones(10,18);
input = [cats dogs];
output = [ cat_lab dog_lab];

h = [];
catdog_net = newff(input, output, h); 
catdog_net = train(catdog_net, input, output,h);
%%
% Now teach a perceptron to tell the difference between random vectors and
% vectors that represent cats. _Do not show the network any dogs._ You will
% need to create a vector full of random numbers using the *rand* command.
cat_lab = ones(1,18);
rand_lab = -ones(1,18);
input = [cats rand(10,18)];
output = [ cat_lab rand_lab ];

cat_net = newff(input,output,h);
cat_net = train(cat_net, input, output,h);
%Started using feedforwardnet function instead


%%
% Once training is complete, ask this 'cat detector' about dogs. That is, look
% at the average error rate (i.e. the average classification error rate)
% when the cat detector is asked about all dogs in the test set. Compare
% (subtract) this to the average error rate of the cat detector when
% shown cats (still from the test set, of course). Which is larger? Use a
% for-loop to do this many times (~100) and take the average of this
% difference over each of these networks.

cat_net = feedforwardnet([]);

% Your code goes here
errors = zeros(2,100);
dog_lab = -ones(1,18);
for x=1:40
    

    cat_lab = ones(1,18);
    rand_lab = -ones(1,18);
    input = [cats rand(10,18)];
    output = [ cat_lab rand_lab ];
    
    
    cat_net = init(cat_net);

    cat_net = train(cat_net,input, output,h);
    out_dog = sim(cat_net, dogs);
    out_cat = sim(cat_net, cats);
    
    errors(1,x) = sum(sign(out_dog) ~= dog_lab(1,:))/18;
    errors(2,x) = sum(sign(out_cat) ~= cat_lab)/18;
end
diff = errors(1,:) - errors(2,:);
avg_err_catsnet = sum(diff)/size(diff,2);
%% 3. Making a 'dog detector'
%%
% In the lab assignment you created a 'cat detector'. Now do the
% converse--make a 'dog detector' and ask it first about cats and then
% dogs.

% Your code goes here



dog_net = feedforwardnet([]);

% Your code goes here
errors = zeros(2,100);
dog_lab = -ones(1,18);
for x=1:40
    

    dog_lab = -ones(1,18);
    rand_lab = ones(1,18);
    input = [cats rand(10,18)];
    output = [ dog_lab rand_lab ];
    
    
    dog_net = init(dog_net);

    dog_net = train(dog_net,input, output,h);
    out_cat = sim(dog_net, cats);
    out_dog = sim(dog_net, dogs);

    
    errors(1,x) = sum(sign(out_cat) ~= cat_lab)/18;
    errors(2,x) = sum(sign(out_dog) ~= dog_lab(1,:))/18;
end
diff = errors(1,:) - errors(2,:);
avg_err_dogsnet = sum(diff)/size(diff,2);

%%
% Compare the average error rates of your cat and dog detectors and comment on any
% differences. Why would these differences occur? _Hint: Look at the
% statistical properties of the dog and cat datasets, using functions like
% *std*._

avg_err_catsnet;
avg_err_dogsnet;
std dogs
std cats

%The dogs std is lower than the cats, giving it lower variance, which
%explains why the cats avg_err variable would be consistantly smaller than
%the cats. They are close, however, which explains why the avg_err's are
%generally close, and why randomness can hide their differences and
%sometimes have cats error less than dogs.

%%
% Lastly, why do you think we asked you to run many different networks and
% average their performance?


%There is so much variability with these given the presence of local
%minima. A linear classifier could correctly separate the training data in
%many different ways, with different biases and slopes. Additionally, we
%are training with random data in both cat_net and dog_net, therefore to
%account for the randomness and variability of answers that can be found,
%running this many times grants a more meaningful result.
