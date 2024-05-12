% Funzione che permette di restituire un dizionario in cui
% (chiave, valore) = (configurazione ridondata come stringa, valore di disponibilità steady-state) 
% dato
% - la disponibilità dei singoli nodi
% - il numero di nodi in serie --> per ragioni implementative, può essere
% solo 4.
% - una soglia di disponibilità
% - il numero massimo di repliche desiderate che si vuole valutare
function [dict_results] = find_configurations(availability_nodes, number_nodes, threshold, max_number_replicas)
conf_index = 1;
for i = 1:1:max_number_replicas
    for j = 1:1:max_number_replicas
        for k = 1:1:max_number_replicas
            for z = 1:1:max_number_replicas
                replicas_founded(conf_index) = sprintf("[%d %d %d %d]", i,j,k,z); %  save the number of replica for each type of node
                result_value(conf_index)  = availability_SoP(availability_nodes, [i j k z], number_nodes); % save the value di steady-state availability
                conf_index = conf_index + 1;
            end
        end
    end
end
% In this part, we filter the configurations given a threshold availability. 
conf_filtered_index = 1;
for h=1:1:conf_index-1
    if(result_value(h) >= threshold)
        replicas_founded_filtered(conf_filtered_index) = replicas_founded(h);
        result_value_filtered(conf_filtered_index) = result_value(h)
        conf_filtered_index = conf_filtered_index + 1;
    end
end
% Create a dict (key, value)=(configuration with redundancy, final value availability) 
dict_results = dictionary(replicas_founded_filtered,result_value_filtered)
end