clc
clear all
format long e

% Specifica il path dei files dei nodi
path_files = ["N1.xml" "N2.xml" "N3.xml" "N4.xml"];
% Estrazione da TimeNET attraverso il suo xml
ava_1 = extract_from_TimeNET(path_files(1))
ava_2 = extract_from_TimeNET(path_files(2))
ava_3 = extract_from_TimeNET(path_files(3))
ava_4 = extract_from_TimeNET(path_files(4))

% Crea una struttura che contiene la disponibilità per ogni nodo
availability_nodes = [ava_1 ava_2 ava_3 ava_4];

% Definizione del numero di nodi in serie
number_nodes = 4;
% Threshold availability: six nines
threshold = 0.9999990;

% Definizione della configurazione utilizzata
no_redundancy_conf = [1 1 1 1];

% Calcolo della disponibilità finale come serie di paralleli
final_availability = availability_SoP(availability_nodes, no_redundancy_conf, number_nodes)