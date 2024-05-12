% Permette di calcolare la serie o il parallelo tra un certo numero di nodi nota
% - la disponibilità di ogni nodo 
% - il numero di nodi
% - la modalità di funzionamento: 
%       mode = 0 --> calcola il parallelo
%       mode = 1 --> calcola la serie
% - flag (repetition) per specificare se i nodi sono tutti dello stesso
%       tipo. Se vale 1, tutti i nodi sono dello stesso tipo e availabilty_nodes 
%       è uno scalare 
function [resultAvailability] = product_block(availability_nodes,number_nodes, mode, repetition)
    resultAvailability = 1;
    if(number_nodes == 1) 
        resultAvailability = availability_nodes(1);
    else
        if (repetition == 1)
            if (mode == 1)
                resultAvailability = availability_nodes(1)^number_nodes;
            else 
                resultAvailability = (1 - availability_nodes(1))^number_nodes;
            end
        else
            for i=1:1:number_nodes
                if (mode == 1)
                    resultAvailability=resultAvailability * availability_nodes(i);
                else
                    resultAvailability=resultAvailability * (1 - availability_nodes(i));
                end
            end
        end
end