data;
k = 3;
k_cnf = k_cnf_learn( examples, labels, k );
dnf = cnf2dnf(k_cnf);
dnf2str(cnf2dnf(k_cnf), header)
