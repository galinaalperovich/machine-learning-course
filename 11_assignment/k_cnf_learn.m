% Function for learning k-CNF expressions
% examples: a matrix, rows are examples, columns are attributes, 1 ...
% true, -1 ... false
% labels: class-labels of the examples, 1 ... positive examples, -1 ...
% negative examples
% k in k-CNF
function [ k_cnf ] = k_cnf_learn( examples, labels, k )
    % Transform the dataset by adding new derived attributes
    % (correponding to k-disjunctions... you can use function 'transform') 
    % and then learn a monotone conjunction on the new representation.
    
    [data, masks] = transform( examples, k );
    
    % pos and neg examples
    p_examples = data(labels == 1,:);
    n_examples = data(labels == -1,:);

    p_examples(p_examples == -1) = 0;
    n_examples(n_examples == -1) = 0;

    m = size(p_examples,2);

    cm = zeros(1,m);

    for i = 1:m
        col = p_examples(:,i);
        cm(i) = col_and(col);
    end


    % Check if the learned conjunction correctly separates the dataset 
    % (otherwise we can return an empty cell array or something to indicate that
    % it is impossible to split the dataset by any k-cnf expression for the given k) -
    % note that monotone conjunctions can be learned just taking into
    % account the positive examples so we also need to check whether the learned
    % conjunction does not cover a negative example


    n_neg = size(n_examples,1);

    negative_sep = 1;

    for i = 1:n_neg
        if all(bitand(n_examples(i,:), cm) == cm)
            negative_sep = 0;
        end
    end

    if negative_sep == 0
        cm = [];
        k_cnf = {};
        return
    end

    %     if ~negative_sep
    %         cm = [];
    %     end

    % The variable cnf should contain the learned cnf expression - it should be a cell array 
    % containing vectors of numbers. Positive numbers denote boolean 
    % attributes from the original data, negative numbers denote negated 
    % attributes from the original data.
    % Example: Let us have three variables - A, B, C, then {[1 -2], [3]}
    % represents the following formula: (A or not B) and C
    k_cnf = {};

    pos_cm_ind = find(cm == 1);
    pos_masks = masks((pos_cm_ind), :);

    [m,n] = size(pos_masks);

    for i = 1:m
        res = [];
        mask_line = pos_masks(i, :);
        pos_var = find(mask_line == 1);
        neg_var = -find(mask_line == -1);
        res = horzcat(res,pos_var);
        res = horzcat(res,neg_var);
        k_cnf{i} = res;
    end

    
end