function [iso] = isomap(X, k, s)

knn_graph=BuildKNNGraph(X,k);

distances = Floyd(knn_graph);

% Multi-dimensional scaling
iso = cmdscale(distances);


end