function [W_knn, W_mutual] = BuildDirectedKNNGraph(S,k)

% BuildDirectedKNNGraph Creates a matrix of an oriented kNN graph from a similarity matrix
%
% W = BuildDirectedKNNGraph(S,k) sets all but k nearest elements to zero
%   
% Input:
%   S = similarity matrix, squared, symmetric, without negative values
%   k = number of nearest neighbours that should be kept 

if (size(S,1) ~= size(S,2))
  error('Matrix is not squared!')
end

[n,m] = size(S);

% Avoid self-loops
for it=1:n
  S(it,it) = 0; 
end


% Initialize the matrix
W_knn = S;


% First variant: not symmetric

for it = 1:n
  % Sort the items
  [sorted_row,order] = sort(S(it,:), 'descend');
  W_knn(it, order(k+1:end)) = 0;
end

W_mutual = W_knn;

% Second variant: symmetric
for i = 1:n
    for j = 1:m
        d1 = W_mutual(i,j);
        d2 = W_mutual(j,i);
        if d1 ~= d2
            W_mutual(j,i) = 0;
            W_mutual(i,j) = 0;
        end
    end
end

  
