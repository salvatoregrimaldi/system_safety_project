% Questo script permette di salvare come delle variabili .mat i valori del
% parametro e relativa disponibilità del nodo nella directory corrente di
% lavoro di MALTAB.
file_names = {'tfDCK.txt', 'trDCK.txt'};
[values_parameter, availability_obtained] = extract_from_SHARPE(file_names);

% Estrazione dei valori di lambda e mu
values_lambda = values_parameter{1};
values_mu = values_parameter{2};

% Salvataggio dei valori di lambda e mu
save('values_lambda_SHARPE.mat', 'values_lambda');
save('values_mu_SHARPE.mat', 'values_mu');

% Estrazione della disponibilità di lambda e mu
availability_obtained_lambda = availability_obtained{1};
availability_obtained_mu = availability_obtained{2};

% Salvataggio dei valori di disponibilità per lambda e mu
save('availability_obtained_lambda_SHARPE.mat', 'availability_obtained_lambda');
save('availability_obtained_mu_SHARPE.mat', 'availability_obtained_mu');



