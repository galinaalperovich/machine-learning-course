min_frequency = 0.03;
frequent_itemsets = my_apriori(tranDb, min_frequency);
rules = associationRules(frequent_itemsets, 0.7, tranDb);
printRules(rules, info, 'rules.txt')