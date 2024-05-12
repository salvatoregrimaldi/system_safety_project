% Permette di calcolare il parallelo tra un certo numero di nodi nota
% - la disponibilità di ogni nodo 
% - il numero di nodi
% - flag (repetition) per specificare se i nodi sono tutti dello stesso
%       tipo. Se vale 1, tutti i nodi sono dello stesso tipo e availabilty_nodes 
%       è uno scalare 
function [result_availability] = parallel_block(availabilty_nodes,number_nodes, repetition)
    if(number_nodes == 1)
        result_availability = availabilty_nodes(1);
    else
        result_availability = 1 - product_block(availabilty_nodes,number_nodes, 0, repetition);
end