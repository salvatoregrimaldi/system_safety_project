% Funzione che permette di estrarre da uno TXT/CSV i valori del parametro
% che deve variare e la disponibilità del nodo dato il path del file dei
% valori.
function [values_parameter, availability_obtained] = extract_from_SHARPE(file_names)

% Inizializza l'array per memorizzare i dati
val_parameter = {};
ava_obtained  = {};

% Leggi i due float separati da virgola
format_spec = '%f,%f';

% Leggi i file TXT e salva i dati
for i = 1:length(file_names)
    % Apri il file TXT corrente
    filename = file_names{i};
    fid = fopen(filename, 'r');

    % Scansione del file TXT
    data = textscan(fid, format_spec);

    % Chiudi il file
    fclose(fid);

    % Estrai i dati
    first_member = data{1};
    second_member = data{2};
    
    %Aggiungi i valori del parametro all'array in posizione i
    val_parameter{i} = first_member;
    
    %Aggiungi i valori di disponibilità all'array in posizione i
    ava_obtained{i} = second_member;
end
    values_parameter = val_parameter;
    availability_obtained = ava_obtained;
end


