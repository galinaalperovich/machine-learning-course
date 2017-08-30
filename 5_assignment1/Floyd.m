function output = Floyd(X_in)

output = inf(size(X_in));
for idx = 1:size(X_in,1)
    output(idx,idx)=0;
end

edges = X_in>0;
output(edges ) = X_in(edges);

for k=1:size(X_in,1)
    for i = 1:size(X_in,1)
        for j=1:size(X_in,1)
            if output(i,j)> output(i,k)+output(k,j)
            output(i,j)= output(i,k)+output(k,j);
            end
        end
    end
end

end