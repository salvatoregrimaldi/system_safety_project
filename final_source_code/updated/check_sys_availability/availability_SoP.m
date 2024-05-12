% Questa funzione ha l'obiettivo di calcolare la serie di paralleli date
% - disponibilità di ogni nodo
% - il numero di repliche per ogni nodo
% - numero di nodi che partecipano alla serie

function [totalAvailability] = availability_SoP(availability_nodes, replicas_for_node, number_nodes)   
    double temp;
    temp = 1;
    repetition = 1;
    % Scorrimento tra tutti i nodi in serie 
    for i=1:1:number_nodes
        % Prima vengono calcolati i paralleli per ogni nodo e poi viene
        % valutata la serie con il blocco precedente (che, a sua volta, può
        % essere la serie di altri blocchi, e così via).
        temp = series_block([parallel_block(availability_nodes(i),replicas_for_node(i), repetition) temp], 2, 0);
    end
    % Ritorno al chiamante della disponibilità complessiva individuata
    totalAvailability = temp;
end