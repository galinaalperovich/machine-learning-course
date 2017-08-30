function [symm]=BuildKNNGraph(X_in, k)

    n_size = size(X_in,1);
    symm=zeros(n_size);
    mutual=zeros(n_size);
%     S(1:(n_size+1):end)=0;
    
    
number_of_points = size(X_in, 1);
S = zeros(number_of_points);
for first_idx = 1:number_of_points
    for second_idx = (first_idx + 1):number_of_points
        distance = norm(X_in(first_idx, :) - X_in(second_idx,:), 2);
        S(first_idx, second_idx) = distance;
        S(second_idx, first_idx) = distance;
    end
end
    
    
    
    for i=1:n_size
        [~, sorted_idx] = sort(S(i,:),'ascend');
        S(i,sorted_idx(k+2:end))=0;
        
    end
    
   
    for i=1:n_size
        for j=1:n_size
            
           
            
            if(max(S(i,j), S(j,i))>0)
                symm(i,j)=max(S(i,j), S(j,i));
                symm(j,i)=max(S(i,j), S(j,i));
            end
            
            
        end
     end



end