% Permette di calcolare la serie tra un certo numero di nodi nota
% - la disponibilità di ogni nodo 
% - il numero di nodi
% - flag (repetition) per specificare se i nodi sono tutti dello stesso
%       tipo. Se vale 1, tutti i nodi sono dello stesso tipo e availabilty_nodes 
%       è uno scalare 
function [result_availability] = series_block(availabilty_nodes,number_nodes, repetition)
    result_availability = product_block(availabilty_nodes,number_nodes, 1, repetition);
end