function [Mean,Std,PG] = estGauss(x, nr_groups, labels)
x = x(labels ~= 0);
labels = labels(labels ~= 0);

Mean = zeros(1,nr_groups);
Std = zeros(1,nr_groups);
PG = zeros(1,nr_groups);

for i = 1:nr_groups
    xi = x(labels == i);
    Mean(i) = mean(xi);
    Std(i) = std(xi);
    PG(i) = length(xi)/length(labels);
end