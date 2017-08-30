function ub = get_ub(n, k)

ub = 0;
for i = 0:k
    ub = ub + nchoosek(n,k) * 2^i;
end