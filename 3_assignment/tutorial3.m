%% 1
% select suitable parameters and generate input data (to check the output
% use function PlotData.m which displays scatter plot; see figures)
K = 2;
[data, labels] = GenerateData(200, [0.5,0.5], 0.01);
PlotData(data,labels, 'Original points')
[labels_kmeans, C] = kmeans(data, K); 

%% 2
% perform clustering using k-means algorithm, evaluate its success rate
% visually using function PlotData.m and numerically using function
% Purity.m,

PlotData(data,labels_kmeans, 'K-means clustering')
pur_kmeans = Purity(labels,labels_kmeans);

%% 3
% create the basic variant of the algorithm of spectral clustering from the
% existing functions

sigma = 0.5;
eps = 0.3;
k = 8;
S = CalcSimMatrix(data,sigma);
% W_knn = BuildEpsilonGraph(S,eps);
[W_knn, W_mutual] = BuildDirectedKNNGraph(S,k);
PlotGraph(data, W_mutual,'Graph')
[eigvecs1, eigvecs2, L1, L2] = CalcLaplacian(W_mutual);
[labels_spectral, C_spectral] = kmeans(eigvecs2, K); 

%% 4
% perform clustering using spectral clustering, check its success visually
% using function PlotData.m and numerically using function Purity.m

PlotData(data, labels_spectral, 'Spectral clustering')
pur_spectral = Purity(labels,labels_spectral);
pur_spectral

%% Looking for perfect fit 

sigmas = 0:0.1:1;
ks = 2:15;
pur_best = 0;
s_best = 0;
k_best = 0;
labels_best = 0;
data_best = 0;
ss_best = 0;
labels_org = 0;

for s = sigmas
    for sigma = sigmas
        for k = ks
            [data, labels] = GenerateData(200, [0.5,0.5], s);
            S = CalcSimMatrix(data,sigma);
            [W_knn, W_mutual] = BuildDirectedKNNGraph(S,k);
            [eigvecs1, eigvecs2, L1, L2] = CalcLaplacian(W_mutual);
            [labels_spectral, C_spectral] = kmeans(eigvecs2, K); 
            pur_spectral = Purity(labels,labels_spectral);
            if pur_spectral > pur_best
                pur_best = pur_spectral;
                s_best = sigma;
                k_best = k;
                labels_best = labels_spectral;
                data_best = data;
                ss_best = s;
                labels_org = labels;
            end  
        end
    end
end

%% Perfect fit for the following params:

PlotData(data_best, labels_best, 'Spectral clustering')
pur_spectral = Purity(labels_org,labels_best);
pur_spectral % 1
s_best %0.1
k_best %8
ss_best %0

%% Theory questions

% Q: Spectral clustering approximates some graph problem. Which? What
% is its complexity class?

% A: Connected component O(|V| + |E|)

% Q: What is the asymptotic time complexity of spectral clustering? Separate
% the analysis the graph generation, spectral decomposition and
% k-means clustering.

% A: 
% graph generation O(n^2)
% spectral decomposition O(n^3)
% k-means clustering O(nkdi), d-dim, i -iterations, n-points, k- clusters
% (Floyed alg) 
% => Spectral clustering O(n^3)


