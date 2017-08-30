function new_data = myKnnInput(data)

[n,m] = size(data);

new_data = [];
for i = 1:n
    d = data(i,:);
    if any(isnan(d)) % has missing value
        idx_nan = find(isnan(d));
        if size(idx_nan, 2) == 3
            new_data = vertcat(new_data, d);
            continue
        end
        for j = 1:size(idx_nan,2)
            idx = idx_nan(j);
            data_filter = data;
            data_filter = data_filter(~any(isnan(data_filter),2),:); % only not NaN rows
            y = data_filter(:,idx);

            d_new = d;
            data_filter(:,idx_nan) = []; % only other columns

            d_new(:,idx_nan) = [];
            mdl = fitcknn(data_filter,y);
            y_est = predict(mdl, d_new);
            d(:,idx) = y_est;
        end
        new_data = vertcat(new_data, d);
        
    else
    new_data = vertcat(new_data, d);
    end
end


end
