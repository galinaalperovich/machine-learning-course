%% generation of data

% k1 is the number of used propositional variables
k1 = 6;
% k2 is the number of propositional variables used in the concept (target conjunction)
k2 = 2;
% We generate the examples, "examples" is a matrix where rows correspond to
% examples and columns correspond to propositional variables (i.e
% attributes). We use 1 for TRUE and -1 for FALSE. "labels" is a  vector of
% labels - 1 for positive examples, -1 for negative examples. "concept" is
% a conjunction which (if noise was set to zero) could correctly split the
% examples to positive and negative ones.
[examples labels concept] = generateExamples(k1, k2, 2000, 0);

% To make things simple, we will have 50-50 proportion of positive and negative examples
ecount = min([sum(labels == 1) sum(labels == -1)]);
positive_examples = examples(labels == 1,:);
positive_examples = positive_examples(1:ecount,:);
negative_examples = examples(labels == -1,:);
negative_examples = negative_examples(1:ecount,:);
examples = [positive_examples; negative_examples];
labels = [ones(1,ecount), -ones(1,ecount)];

positive_examples = positive_examples(randperm(size(positive_examples,1)),:);
negative_examples = negative_examples(randperm(size(negative_examples,1)),:);

% 100 positive examples and 100 negative examples are used for training, the rest for testing
train_set_size = 200;
pos = min([size(positive_examples,1) train_set_size/2]);
neg = min([size(negative_examples,1) train_set_size/2]);
positive_train_examples = positive_examples(1:pos,:);
negative_train_examples = negative_examples(1:neg,:);
train = [positive_train_examples; negative_train_examples];
positive_train_labels = ones(1,pos);
negative_train_labels = -ones(1,neg);
train_labels = [positive_train_labels, negative_train_labels];
positive_test = positive_examples((pos+1):end,:);
negative_test = negative_examples((neg+1):end,:);
test = [positive_test; negative_test];
test_labels = [ones(1,size(positive_test,1)), -ones(1,size(negative_test,1))];

%% an example how to construct learning curves

figure;

% the function "conj_learningCurve" constructs a learning curve without
% averaging (as opposed to the function with the same name used in the previous assignment)

xs = [];
ys = [];
delta = 0.2;
text_labels = {};
k = 5;
% the function "conj_learningCurve" constructs a learning curve as an
% average of several learning curves
lc = conj_learningCurve(@conj_bb, k, train, test, train_labels, test_labels);
xs = [xs, ((1:length(lc))/length(lc))'];
ys = [ys, lc'/size(test,1)];
prop = 0.1:0.1:1;
ub = ys' + sqrt( (1./(2*prop*size(train,1))) * log(get_ub(size(train,2), k)/delta) );
text_labels = [text_labels {['k = ' num2str(k)]}]
plot(xs, ys, xs, ub);


legend(text_labels);



