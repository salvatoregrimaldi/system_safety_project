% Questa funzione permette l'estrazione dal file .XML generato da TimeNET.

function [availability] = extract_from_TimeNET(path_file)
% Leggi il file XML
xml_doc = xmlread(path_file);

% Trova tutti i tag 'measure' nel documento (nel nostro caso, solo 1)
measure_items = xml_doc.getElementsByTagName('measure');

% Inizializza un cell array per contenere i valori dell'attributo 'result'
resultValues = {};

% Estrai il valore dell'attributo 'result' per ogni tag 'measure' dove 'name' è 'availability'
for k = 1:measure_items.getLength()
    if strcmp(char(measure_items.item(k-1).getAttribute('name')), 'availability')
        resultValues{end+1} = char(measure_items.item(k-1).getAttribute('result'));
    end
end

% Ora resultValues contiene i valori dell'attributo 'result' per tutti i tag 'measure' dove 'name' è 'availability'
availability = str2double(resultValues{1});
end