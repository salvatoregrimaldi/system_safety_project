% Procedura di stima a massima verosimiglianza dei tassi di guasto (time censoring) e di riparazione (campione completo)
% Si assumano tempi di guasto e riparazione esponenziali per il componente
rng(2023);

% Carica il file .mat
data = load('repairs_gr1.mat');

% Determina il nome della variabile contenuta nel file
varName = fieldnames(data);

% Estrai i tempi di riparazione
repairTimes = data.(varName{1});

% Calcola il numero di campioni 
nsamps = length(repairTimes);

% Stima del parametro mu utilizzando il metodo di massima verosimiglianza
%mu_hat = 1 / mean(repairTimes);
mu_hat = 1 / (sum(repairTimes) / nsamps);

% Exp distribution fit function
[muhat,muci] = expfit(repairTimes)
% mle() function
muml = mle(repairTimes,'Distribution','Exponential')

% Stampa il tasso di riparazione stimato
fprintf('Il tasso di riparazione stimato mu è %f\n', mu_hat);
fprintf('Il MTTR stimato è %f\n', 1/mu_hat);

% Istogramma vs pdf stimata
figure
histogram(repairTimes,'Normalization', 'pdf');
title('RepairTimes: complete sample', 'FontSize', 24)
xlabel('repairTimes', 'FontSize', 20)
ylabel('pdf', 'FontSize', 20)
ax = gca;
ax.FontSize = 16;
hold on;
xax = linspace(0, ax.XLim(2), 100);
plot(xax, exppdf(xax,muhat), 'r:', 'LineWidth', 2)
legend('hist','est.', 'FontSize', 20)

% Carica i file .mat
failureData = load('failures_gr1.mat');
censoringData = load('censoring_gr1.mat');
length(censoringData)

% Determina il nome delle variabili contenute nei file
failureVarName = fieldnames(failureData);
censoringVarName = fieldnames(censoringData);

% Estrai i tempi di guasto e i dati di censura
failureTimes = failureData.(failureVarName{1});
censoring = censoringData.(censoringVarName{1});

[lambdaEst,lambdaIC] = expfit(failureTimes, 0.05, censoring)

% Seleziona solo i tempi di guasto non censurati
nonCensoredFailureTimes = failureTimes(censoring == 0);

% Calcola il numero di campioni non censurati
nsamps_nocens = length(nonCensoredFailureTimes);
nsamps_tot=length(failureTimes);

% Stima del parametro lambda utilizzando il metodo di massima verosimiglianza
lambda_hat = 1 / (sum(failureTimes) / nsamps_nocens);
lambda_wr=1/(sum(failureTimes)/nsamps_tot);





% mle() function with right censoring
mumlrc = mle(failureTimes,'Distribution','Exponential','Censoring',censoring)

% Stampa il tasso di guasto stimato
fprintf('Il tasso di guasto stimato lambda è %f\n', lambda_hat);
fprintf('Il MTTF stimato è %f\n', 1/lambda_hat);

% Istogramma vs pdf stimata
figure
histogram(failureTimes(find(censoring==0)),'Normalization', 'pdf');
title('Failure times: type I right censoring', 'FontSize', 24)
xlabel('failureTimes (uncensored)', 'FontSize', 20)
ylabel('pdf', 'FontSize', 20)
ax = gca;
ax.FontSize = 16;
hold on;
xax = linspace(0, ax.XLim(2), 100);
plot(xax, exppdf(xax,1/lambda_hat), 'r:', 'LineWidth', 2)
plot(xax, exppdf(xax,1/lambda_wr), 'k:', 'LineWidth', 2)
legend('hist','est.','wrong est. with stopping times', 'FontSize', 20)
