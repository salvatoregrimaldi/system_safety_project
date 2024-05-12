import os
import subprocess
import time
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

def ava_update_files(namefiles, tested_value,  trans_to_change): #tested_value è in ore
    """This function accesses the files whose names are in 'namefiles', that are Sharpe descriptions of some SRNs,
    and updates in each of them the timed transition 'trans_to_change' to the value 'tested_value'; then it uses
    the Sharpe tool to compute the steady-state availability of each SRN, and prints the results in new text files
    located inside the 'C:\Sharpe-Gui\sharpe' folder.


    Args:
        namefiles (list): list of the names of files containing the Sharpe descriptions of the considered nodes.
        tested_value (float): value to use as reciprocal of the rate for the timed transition 'trans_to_change'. It is expressed in hours.
        trans_to_change (str): the timed transition whose value must be changed.
    """
    for namefile in namefiles:
        
        file = open('C:\Sharpe-Gui\sharpe\\' +namefile, 'r')
        lines = file.readlines()
        for i, line in enumerate(lines):
            if line.startswith("  " +trans_to_change +" ind"):
                lines[i] = "  " +trans_to_change +" ind 1/(" +str(tested_value) +")" +"\n"
                break
        file.close()

        file = open('C:\Sharpe-Gui\sharpe\\' +namefile, 'w')
        file.writelines(lines)
        file.close
        
        file = open('C:\Sharpe-Gui\sharpe\\' +'result_' +namefile, 'w')
        command = "cd C:\Sharpe-Gui\sharpe & sharpe " +namefile +">" "result_" +namefile +" & exit"
        p = subprocess.Popen(["start", "cmd", "/k", command], shell = True)
        file.close()

        

def compute_ava(namefiles = [], configuration = [1,1,1,1]):
    """This function accesses the files whose names are in 'namefiles', that contain the steady-state availabilities of the
    considered nodes, and computes the steady-state availability of the redundant configuration specified by means of the 
    parameter 'configuration'.

    Args:
        namefiles (list, optional): list of the names of files containing the steady-state availability of
                                    each of the considered nodes. 
                                    Defaults to [].
        configuration (list, optional): list of int representing the redundant configuration that must be evaluated.
                                        Defaults to [1,1,1,1].

    Returns:
        ava_series (float): the steady-state availability of the redundant configuration
    """    
    ava_node = [0,0,0,0]
    j=0
    for namefile in namefiles:
        file = open('C:\Sharpe-Gui\sharpe\\' +namefile, 'r')
        lines = file.readlines()
        for i, line in enumerate(lines):
            if 'SS_ExpectedRewardRate' in line:
                ava_node[j] = line.split()[1]
                j+=1
                break
        file.close()
    ava_node = [float(i) for i in ava_node]
    ava_redundant_1 = 1 - ((1-ava_node[0])**configuration[0])
    ava_redundant_2 = 1 - ((1-ava_node[1])**configuration[1])
    ava_redundant_3 = 1 - ((1-ava_node[2])**configuration[2])
    ava_redundant_4 = 1 - ((1-ava_node[3])**configuration[3])
    ava_series = ava_redundant_1 * ava_redundant_2 * ava_redundant_3 * ava_redundant_4
    print(ava_series)
    return ava_series

        

def ava_write_csv(namefiles, csv_file, configuration, lower_extreme, upper_extreme, step, critical_value, trans_to_change, critical_ava):
    """This function writes in a new csv file the steady-state availabilities of a redundant configuration,
    for different values of the reciprocal of the rate of a timed transition.

    Args:
        namefiles (list): list of the names of files containing the steady-state availability of
                          each of the considered nodes. 
        csv_file (str): file where the tested reciprocal of rates and the obtained availabilities must be written.
        configuration (list): list of int representing the redundant configuration that must be evaluated.
        lower_extreme (float): lower extreme of the interval of values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'. It is expressed in hours.
        upper_extreme (float): upper extreme of the interval of values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'. It is expressed in hours.
        step (float): interval between values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'.
        critical_value (float): value of the reciprocal of the rate of the timed transition 'trans_to_change' for which the steady-state availability
                                of the redundant configuration is known to be equal to 'critical_ava'. It is expressed in hours.
        trans_to_change (str): the timed transition whose value must be changed.
        critical_ava (float): a critical value of the steady-state availability of the redundant configuration for which it is known the correspondent 'critical-value'
    """
    file = open('C:\Sharpe-Gui\sharpe\\' +csv_file, 'w')
    file.write("reciprocal_of_rate,availability\n")
    file.write(str(critical_value) +"," +str(critical_ava) +"\n")
    for tested_value in np.arange(lower_extreme, upper_extreme, step):
        ava_update_files(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
                            tested_value=tested_value, trans_to_change=trans_to_change)
        time.sleep(2)
        ava_series = compute_ava(namefiles = ["result_node1code.txt", "result_node2code.txt", "result_node3code.txt", "result_node4code.txt"], configuration = configuration)
        file.write(str(tested_value) +"," +str(ava_series) +"\n")
    file.close()





def ava_sens(namefiles, margin, configuration, lower, upper, step, ava_target, trans_to_change, direction):
    """This function performs an automatic sensitivity analysis, in fact it finds the critical value of the reciprocal of the rate
    of 'trans_to_change' for which the steady-state availability of the provided redundant configuration goes down to 'ava_target'.

    Args:
        namefiles (list): list of the names of files containing the Sharpe descriptions of the considered nodes.
        margin (float): accepted difference between the computed availability and the target availability specified by 'ava_target'.
        configuration (list): list of int representing the redundant configuration that must be evaluated.
        lower (float): lower extreme of the interval of values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'. It is expressed in hours.
        upper (float): upper extreme of the interval of values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'. It is expressed in hours.
        step (float): interval between values to be tested as reciprocal of the rate of the timed transition 'trans_to_change'.
        ava_target (float): steady-state availability that must be achieved in the context of the conducted sensitivity analysis.
        trans_to_change (float): the timed transition whose value must be changed.
        direction (str): it specifies the direction in which the changing of 'trans_to_change' determines the decreasing of the steady-state availability.
                         It must be "if_upper_worse" for repair transitions and "if_lower_worse" for failure transitions.

    Returns:
        float: the critical value, expressed in hours, for which the steady-state availability is equal to 'ava_target'.
    """    
    if(direction != "if_lower_worse" and direction != "if_upper_worse"):
        raise ValueError("direction must be 'if_lower_worse' or 'if_upper_worse'")
    if(direction == "if_upper_worse"):
        for tested_value in np.arange(lower, upper, step):
            print(str(tested_value) + " h")
            ava_update_files(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
                            tested_value=tested_value, trans_to_change=trans_to_change)
            time.sleep(2)
            ava_series = compute_ava(namefiles = ["result_node1code.txt", "result_node2code.txt", "result_node3code.txt", "result_node4code.txt"], configuration = configuration)
            if(ava_series < ava_target):
                if(ava_target - ava_series <= margin):
                    print(ava_target-ava_series)
                    print("Valore critico trovato a %f h e ava=%.10f" %(tested_value, ava_series))
                    return tested_value
                else:
                    print("Sono vicino ma non troppo %f h e ava=%.10f" %(tested_value, ava_series))
                    new_lower = tested_value - step
                    print("new lower = %f h" %(new_lower))
                    new_upper = tested_value
                    print("new upper = %f h" %(new_upper))
                    #return tested_value
                    return ava_sens(namefiles, margin, configuration, new_lower, new_upper, step/10, ava_target, trans_to_change, direction)
        print("Ciclo finito, occorre aumentare upper")
        return ava_sens(namefiles, margin, configuration, lower, upper*2, step, ava_target, trans_to_change, direction)
    elif (direction == "if_lower_worse"):
        for tested_value in np.arange(upper, lower, -step):
            print(str(tested_value) + " h")
            ava_update_files(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
                            tested_value=tested_value, trans_to_change=trans_to_change)
            time.sleep(2)
            ava_series = compute_ava(namefiles = ["result_node1code.txt", "result_node2code.txt", "result_node3code.txt", "result_node4code.txt"], configuration = configuration)
            if(ava_series < ava_target):
                if(ava_target - ava_series <= margin):
                    print(ava_target-ava_series)
                    print("Valore critico trovato a %f h e ava=%.10f" %(tested_value, ava_series))
                    return tested_value
                else:
                    print("Sono vicino ma non troppo %f h e ava=%.10f" %(tested_value, ava_series))
                    new_lower = tested_value 
                    print("new lower = %f h" %(new_lower)),
                    new_upper = tested_value + step
                    print("new upper = %f h" %(new_upper))
                    #return tested_value
                    return ava_sens(namefiles, margin, configuration, new_lower, new_upper, step/10, ava_target, trans_to_change, direction)
        print("Ciclo finito, dobbiamo diminuire lower")
        return ava_sens(namefiles, margin, configuration, lower/2, upper, step, ava_target, trans_to_change, direction)

            

    

ava_sens(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
    margin=10**(-12), configuration = [3,3,3,3], lower=5000/3600, upper=7000/3600, step = 1000/3600, \
    ava_target=0.999999, trans_to_change="T_rDCK", direction = "if_upper_worse")

#OSSERVAZIONE IMPORTANTE: dopo aver chiamato ava_sens() per T_rDCK,
# prima di poter fare la chiamata successiva ad ava_sens() per T_fDCK
# è importante assicurarsi di andare a modificare i file Sharpe contenenti le descrizioni delle SRNs,
# rimettendo al posto di T_rDCK il suo valore nominale.

"""ava_sens(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
    margin=10**(-12), configuration = [3,3,3,3], lower=100, upper=200, step = 10, \
    ava_target=0.999999, trans_to_change="T_fDCK", direction = "if_lower_worse")"""



"""
ava_write_csv(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
    csv_file = "fileCSV.txt", configuration = [3,3,3,3], lower_extreme = 10, upper_extreme = 2000, step = 10, \
    critical_value = 131.3875, trans_to_change = "T_fDCK", critical_ava = 0.999999)
"""


"""ava_write_csv(namefiles = ["node1code.txt", "node2code.txt", "node3code.txt", "node4code.txt"], \
    csv_file = "fileCSV2.txt", configuration = [3,3,3,3], lower_extreme = 1/3600, upper_extreme = 2, step = 0.02, \
    critical_value = 1.470904, trans_to_change = "T_rDCK", critical_ava = 0.999999)"""




