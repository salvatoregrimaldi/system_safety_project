%% Caricamento del dataset dei valori del lambda failure e repair rate - versione per dati da SHARPE 

% Threshold availability: six nines
threshold = 0.9999990; 

%% Parametro lambda_DCK
format long 
% Caricamento delle variabili dal file .mat
availability_obtained_lambda_final = importdata('availability_obtained_lambda_SHARPE.mat');
values_lambda_final = importdata('values_lambda_SHARPE.mat');
current_value_lambda = 1500;

% Plot del risultato evidenziando con una stella il valore critico del
% parametro, oltre alla soglia e all'interpolazione dei punti di
% availability del sistema raccolti in TimeNET.

index_critical_value_lambda = find(availability_obtained_lambda_final == threshold);
critical_value_lambda = values_lambda_final(index_critical_value_lambda);

figure('name','Docker failure rate')
plot(values_lambda_final(index_critical_value_lambda-2:length(values_lambda_final)), availability_obtained_lambda_final(index_critical_value_lambda-2:length(values_lambda_final)), 'Color', 'black','MarkerSize',8)
hold on
plot(critical_value_lambda, threshold, "pentagram", 'MarkerSize', 20, 'MarkerFaceColor','red')
plot(values_lambda_final(index_critical_value_lambda-2:length(values_lambda_final)), availability_obtained_lambda_final(index_critical_value_lambda-2:length(values_lambda_final)), 'LineWidth',1.25, 'Color','blue')
x1 = xline(current_value_lambda,'--', '$\mathrm{\mathbf{Nominal\;value}}$', 'Interpreter','latex', 'Color', '#66CC00');
yline(threshold,'--', '$\mathrm{Threshold}$', 'Interpreter','latex');
title("$\mathrm{Influence\;of\;the\;\mathbf{docker\;failure\;rate}\;on\;the\;overall\;system}$", 'interpreter', 'latex')
xlabel('$1/\lambda_{DCK}\;[h]$', 'Interpreter','latex') 
ylabel('$A_{SS}$', 'Interpreter','latex') 

text(values_lambda_final(index_critical_value_lambda),threshold,sprintf('$$\\;\\;\\;1/\\lambda_{DCK}^* = %.2f\\;h$$', critical_value_lambda), 'interpreter','latex', 'FontSize',12, 'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'top');

%% Parametro mu_DCK
% Si procede analogamente al parametro lambda_DCK.

% Caricamento del .mat
availability_obtained_mu_final = importdata('availability_obtained_mu_SHARPE.mat');
values_mu_final = importdata('values_mu_SHARPE.mat');
current_value_mu = 10/3600;

% Plot del risultato


index_critical_value_mu = find(availability_obtained_mu_final == threshold);
critical_value_mu = values_mu_final(index_critical_value_mu);

figure('name','Docker repair rate')
plot(values_mu_final(1:index_critical_value_mu + 2), availability_obtained_mu_final(1:index_critical_value_mu + 2), 'LineWidth',1.25, 'Color','blue')
hold on
plot(critical_value_mu, threshold, "pentagram", 'MarkerSize', 20, 'MarkerFaceColor','red')
x1 = xline(current_value_mu,'--', '$\mathrm{\mathbf{Nominal\;value}}$', 'Interpreter','latex', 'Color', '#66CC00');
yline(threshold,'--','$\mathrm{Threshold}$', 'Interpreter','latex');
title("$\mathrm{Influence\;of\;the\;\mathbf{docker\;repair\;rate}\;on\;the\;overall\;system}$", 'interpreter', 'latex')
xlabel('$1/\mu_{DCK}\;[h]$', 'Interpreter','latex') 
ylabel('$A_{SS}$', 'Interpreter','latex') 
text(critical_value_mu,threshold,sprintf('$$\\;\\;\\;1/\\mu_{DCK}^* = %.2f\\;h\\;\\;$$', critical_value_mu), 'interpreter','latex', 'FontSize',12, 'HorizontalAlignment', 'right', ...
     'VerticalAlignment', 'cap');

