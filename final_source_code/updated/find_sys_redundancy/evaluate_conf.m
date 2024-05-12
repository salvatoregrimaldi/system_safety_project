% Questo script permette di individuare un certo numero di configurazioni ridondate

% Acquisizione della disponibilità steady-state da ogni nodo
check_sys

% Definisce il numero massimo di repliche in ogni nodo
max_number_replicas = 4;

% Soglia di disponibilità stazionaria: six nines
threshold = 0.999999; 

% Trova tutte le configurazioni superiori ad una certa soglia.
all_accepted_configurations = find_configurations(availability_nodes, number_nodes, threshold, max_number_replicas)

