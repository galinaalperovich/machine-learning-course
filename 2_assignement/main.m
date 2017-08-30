% Data generation 

m1 = 152;
s1 = 9;
m2 = 178;
s2 = 10;

m_all = (m1 + m2)/2;
s_all = sqrt((1/2) * s1*s1 + (1/2) * s2*s2 + (1/4) * (m1 - m2)^2);

% We generate data for girls, boys and all separately
data1 = m1 + randn([100,1]) * s1;
data2 = m2 + randn([100,1]) * s2;
data = vertcat(data1, data2);
all = m_all + randn([100,1]) * s_all;

% % % % % % % % % % % % % % % % % 
% I taks. Analysis of all people
% % % % % % % % % % % % % % % % % 

% Probability density estimation from histogram
[bins, center] = hist(all);

% If we want PDF we need to normalize it
% We can not just devide it by the sum, we need to devide it by area (integral)
% sum_bins does not equal 1 because we did not normalize it yet: 
sum_bins = sum(bins) * diff(center(1:2));

dx = diff(center(1:2));
new_bins = bins/ (sum(bins) * dx);

% Alternative with trapz function:
% new_bins = bins/ trapz(center, bins);

% now it is equal 1 => it is PDF
sum_new_bins = sum(new_bins) * diff(center(1:2));

bar(center, new_bins); hold on

% Let's estimate params for normal dist for all variable

m_est = mean(all);
s_est = std(all);

x = 120:0.01:210;
est_pdf = normpdf(x, m_est, s_est);
theor_pdf = normpdf(x, m_all, s_all);
plot(x, est_pdf, 'r');hold on
plot(x, theor_pdf, 'g');hold off;

%% Run EM and estimate params
% % % % % % % % % % % % % % % % % 
% II taks. EM algorithm
% % % % % % % % % % % % % % % % % 

[bins, center] = hist(data);
sum_bins = sum(bins) * diff(center(1:2));
dx = diff(center(1:2));

new_bins = bins/ trapz(center, bins);

% Plot gaussian for each component

bar(center, new_bins); hold on

% Estimated density with kernel density function
[f, xi] = ksdensity(data, center);
% plot(center, f, 'r'); hold on

% Estimated params with EM
nr_groups = 2;
[Mean, Std, PG] = EM(data, nr_groups);
x = 120:0.01:210;

% Estimated pdf with EM:
m1_est = Mean(1);
m2_est = Mean(2);
s1_est = Std(1);
s2_est= Std(2);


pdf1_est = normpdf(x, m1_est, s1_est);
pdf2_est = normpdf(x, m2_est, s2_est);

% Theoretical pdf:
pdf1_theor = normpdf(x, m1, s1);
pdf2_theor = normpdf(x, m2, s2);

% we need to devide them by 2 because we want to create kind of one
% distribution which sum to 1
plot(x, pdf1_est/2, 'r'); hold on
plot(x, pdf2_est/2, 'r'); hold on

plot(x, pdf1_theor/2, 'g'); hold on
plot(x, pdf2_theor/2, 'g'); hold off

%% Plot mixture model 

bar(center, new_bins); hold on

% Cinstruct estimated mixture model
mus_est = [m1_est; m2_est];              
% gmdistribution takes variance, not std! 
sigma_est = cat(3, s1_est*s1_est, s2_est*s2_est);
gmm_est = gmdistribution(mus_est, sigma_est, PG);
fplot(@(x) pdf(gmm_est,x), [130 210], 'g'); hold on

% Construct theoretical mixture model
mus = [m1; m2];              
% gmdistribution takes variance, not std! 
sigmas = cat(3, s1*s1, s2*s2);
p = [0.5, 0.5];
gmm_theor = gmdistribution(mus, sigmas, p);
fplot(@(x) pdf(gmm_theor,x), [130 210], 'r'); hold off

%% Experiments with the labels
data_new = data;
labels = vertcat(repmat(1,[100,1]), repmat(2,[100,1]));
L_train = randsample(200, 140);
data_train = data_new(L_train);
labels_train = labels(L_train);

data_new(L_train) = [];
labels(L_train) = [];
data_test = data_new;
labels_test = labels;


%% Working with train data

%% Training + 10%,20%,50% of labels (without EM)

n = size(data_train,1);

L10 = randsample(n, n - n * 0.1);
L20 = randsample(n, n - n * 0.2);
L50 = randsample(n, n - n * 0.5);
labels10 = labels_train;
labels20 = labels_train;
labels50 = labels_train;

labels10(L10) = 0;
labels20(L20) = 0;
labels50(L50) = 0;

[Mean10, Std10, PG10] = estGauss(data_train, nr_groups, labels10);
[Mean20, Std20, PG20] = estGauss(data_train, nr_groups, labels20);
[Mean50, Std50, PG50] = estGauss(data_train, nr_groups, labels50);

% Theoretical pdf:
pdf1_theor = normpdf(x, m1, s1);
pdf2_theor = normpdf(x, m2, s2);

% Annotated
M_l = Mean20;
Std_l = Std20;
p1 = PG20(1);
p2 = PG20(2);
pdf1_ann = normpdf(x, M_l(1), Std_l(1));
pdf2_ann = normpdf(x, M_l(2), Std_l(2));


bar(center, new_bins); hold on

plot(x, pdf1_theor/2, 'g'); hold on
plot(x, pdf2_theor/2, 'g'); hold on

plot(x, pdf1_ann * p1, 'y'); hold on
plot(x, pdf2_ann * p2, 'y'); hold off

%% Mixture with labels (Theoretical, Estimated, Labels without EM)

m_l = Mean10';
s_l = Std10;
p_l = PG10;

bar(center, new_bins); hold on

% Construct estimated mixture model
mus_est = [m1_est; m2_est];              
% gmdistribution takes variance, not std! 
sigma_est = cat(3, s1_est*s1_est, s2_est*s2_est);
gmm_est = gmdistribution(mus_est, sigma_est, PG);
fplot(@(x) pdf(gmm_est,x), [130 210], 'g'); hold on

% Construct theoretical mixture model
mus = [m1; m2];              
% gmdistribution takes variance, not std! 
sigmas = cat(3, s1*s1, s2*s2);
p = [0.5; 0.5];
gmm_theor = gmdistribution(mus, sigmas, p);
fplot(@(x) pdf(gmm_theor,x), [130 210], 'r'); hold on


% Construct labeled mixture model              
sigmas = cat(3, s_l(1)*s_l(1), s_l(2)*s_l(2));
gmm_l = gmdistribution(m_l, sigmas, p_l);
fplot(@(x) pdf(gmm_l,x), [130 210], 'y'); hold off


%% Training + EM

[Mean_train, Std_train, PG_train] = EM_new(data_train, nr_groups, labels50);
sigmas = cat(3, Std_train(1)*Std_train(1), Std_train(2)*Std_train(2));
gmm_train = gmdistribution(Mean_train, sigmas, PG_train);


%% GMM_l VS GMM_train
data_test_est_l = posterior(gmm_l, data_test);
data_test_est_tr = posterior(gmm_train, data_test);

err_l = 0;
err_tr = 0;

n = size(data_test_est_tr, 1);

for i = 1:n
    v_l = data_test_est_l(i,:);
    v_tr = data_test_est_tr(i,:);
    l = labels_test(i);
    
    if (v_l(1) > 0.5 && l == 2) || (v_l(2) > 0.5 && l == 1)
        err_l = err_l + 1;
    end
    
    if (v_tr(1) > 0.5 && l == 2) || (v_tr(2) > 0.5 && l == 1)
        err_tr = err_tr + 1;
    end      
end


err_l_final = err_l/n;
err_tr_final = err_tr/n;


%% Answers 
% 1. Prior distribution - Bernoulli

% 2. M = p1*m1 + p2*m2 = (m1+m2)/2 = 169 cm
% V = sqrt(p1 * s1 + p2 * s2 + p1p2 * (m1 - m2)^2);

% 3. First of all, it is possible that EM converges to a local min, 
% a local max, or a saddle point of the likelihood function. 
% More precisely, EM is guaranteed to converge to a point with zero gradient.



