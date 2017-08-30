function iso = isomap(X, n_dim, n_neighbors)

[W_knn, W_mutual] = BuildDirectedKNNGraph(X, n_neighbors);


end