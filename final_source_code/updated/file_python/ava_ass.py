def ava_ass(ava1, ava2, ava3, ava4, desired_ava = 0.99999, max_redundancy=5):
    """This function takes in input the steady-state availabilities of 4 nodes and computes 
    the steady-state avalabilities of all the redundant configurations between [1, 1, 1, 1]
    and [max_redundancy, max_redundancy, max_redundancy, max_redundancy], printing the ones
    that are at least equal to the desired_ava.

    Args:
        ava1 (float): steady-state availability of node N1.
        ava2 (float): steady-state availability of node N2.
        ava3 (float): steady-state availability of node N3.
        ava4 (float): steady-state availability of node N4.
        desired_ava (float): desired steady-state availability of the configuration.
        max_redundancy (int, optional): Maximum number of replicas for each node.
                                        It is intended to bound the search space of optimal configurations.
                                        Defaults to 6.
    """
    for i in range(1, max_redundancy):
        for j in range(1, max_redundancy):
            for k in range(1, max_redundancy):
                for v in range(1, max_redundancy):
                    ava_redundant_i = 1 - ((1-ava1)**i)
                    ava_redundant_j = 1 - ((1-ava2)**j)
                    ava_redundant_k = 1 - ((1-ava3)**k)
                    ava_redundant_v = 1 - ((1-ava4)**v)
                    ava_series = ava_redundant_i * ava_redundant_j * ava_redundant_k * ava_redundant_v
                    if(ava_series >= desired_ava):
                        print("[{}, {}, {}, {}] --> {}".format(i, j, k, v, ava_series))
    

# Le steady-state availability seguenti sono state ottenute con il tool Sharpe
ava1 = 0.99621419
ava2 = 0.99621419
ava3 = 0.99620152
ava4 = 0.99520173

# chiamata alla funzione ava_ass() per l'individuazione delle configurazioni che garantiscono i six nines
ava_ass(ava1, ava2, ava3, ava4)




