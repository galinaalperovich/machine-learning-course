function ass_rules = associationRules(frequent_itemsets, min_conf, tranDb)
    ass_rules = {};
    
    
    for item_idx = 1:size(frequent_itemsets,1)
        item_set = frequent_itemsets{item_idx};
        subsets = logical(dec2bin(1:2^length(item_set)-1,length(item_set))-'0');
        
        support = sum(all(tranDb(:,item_set)==1,2));
        
        for i = 1:(size(subsets,1)-1)
            
            subset_support = sum(all(tranDb(:,item_set(subsets(i,:)))==1,2));
            if support/subset_support >= min_conf
                ass_rules{end+1,1} = item_set(subsets(i,:));
                ass_rules{end,2} = item_set(~subsets(i,:));
                ass_rules{end,3} = support/size(tranDb,1);
                ass_rules{end,4} = (support/subset_support);
            end
            
        end
        
        
    end
    
    
    
end