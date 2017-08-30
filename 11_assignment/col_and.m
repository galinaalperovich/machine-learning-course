function bit_and = col_and(arr)

bit_and = 1;
for i=1:size(arr,1)
    bit_and = bitand(bit_and, arr(i));
end