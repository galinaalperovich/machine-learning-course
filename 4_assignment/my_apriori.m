function [frequent_itemsets] = my_apriori(database, min_frequency)
tic
    candidates = {};
    for i = 1:size(database,2)
        candidates{i,1} = [i];
    end
    candidates = prune_itemsets(candidates, database, min_frequency);
    frequent_itemsets = candidates;
    
    n=size(database,2);
    i=1:n;
    % Here, you should fill in the code of the apriori algorithm 
    % (see slides of the lecture: "APRIORI algorithm")
    output_frequent={};
    while size(frequent_itemsets,1)>0
        
        output_frequent = [output_frequent; frequent_itemsets];
        cand = apriori_gen(frequent_itemsets,i);
        frequent_itemsets=prune_itemsets(cand,database,min_frequency);
        
    end
    size(output_frequent,1)
    frequent_itemsets=output_frequent;
    toc
end

function unique_elements = unique_cell(c)
    n = size(c, 2);
    els = [];
    for i = 1:n
        els = [els, c{i}];
    end
    unique_elements = sort(unique(els));
end
function nextWords = apriori_gen(words, sortedA)
%-----------------------------------------------------------
% created by Jan Hrdlicka, 16.9.2010
%-----------------------------------------------------------
% Generates next level words(itemsets).
% input is cell array "words" with words (arrays of items represented by numbers)
% and vector of sorted items "sortedA" with size 1xM, where M is number of
% items. 
% Size of the cell array "words" is Nx1, where N is number of words. Word
% is vector with size 1xI, where I is number of items in the current word.
    nextWords = {};
    for i = 1:size(words,1)
        actWord = words{i,1};
        ind = find(sortedA==actWord(end));
        if ind~=length(sortedA)
            for j = sortedA(ind+1:end)
                candidate = [actWord j];
                for drop = 1:size(candidate,2)
                    subset = [candidate(1:drop-1), candidate(drop+1:end)];
                    contains = false;
                    
                    for word = 1:size(words,1)
                        if isequal(words{word}, subset)
                            contains=true;
                            break;
                        end                           
                    end
                    if ~contains
                        break;
                    end                    
                end
                if contains              
                    nextWords{end+1,1} = [actWord j];
                end
            end
        end
    end
end

function pruned_itemsets = prune_itemsets(itemsets, database, min_frequency)
    frequencies = compute_frequencies(itemsets, database);
    pruned_itemsets = itemsets(frequencies >= min_frequency);
end

function frequencies = compute_frequencies(itemsets, database)
    database_length = size(database,1);
    itemsets_count = length(itemsets);
    frequencies = ones(1,itemsets_count);
    for i = 1:itemsets_count
        itemset = itemsets{i};
        frequencies(i) = sum(all(database(:,itemset)==1,2))/database_length;
    end
end