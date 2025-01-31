clc; close all; clear all;  % Limpa a janela de comando, fecha todas as janelas de figuras e remove todas as variáveis do workspace.

% Definindo parâmetros para o primeiro sinal
f1 = 2_000;              % Frequência do primeiro sinal (2000 Hz)
T1 = 1/f1;              % Período do primeiro sinal
phi1 = 0;               % Fase do primeiro sinal (0 radianos)
A1 = 1;                 % Amplitude do primeiro sinal

% Definindo parâmetros para o segundo sinal
f2 = 2*f1;              % Frequência do segundo sinal (4000 Hz, que é o dobro da primeira frequência)
T2 = 1/f2;              % Período do segundo sinal
phi2 = pi/2;           % Fase do segundo sinal (π/2 radianos)
A2 = 1;                 % Amplitude do segundo sinal

% Definindo parâmetros para o terceiro sinal
f3 = 4*f1;              % Frequência do terceiro sinal (8000 Hz, que é o quadruplo da primeira frequência)
T3 = 1/f3;              % Período do terceiro sinal
phi3 = pi;              % Fase do terceiro sinal (π radianos)
A3 = 1;                 % Amplitude do terceiro sinal

% Definindo parâmetros de amostragem
fs = 40 * f3;           % Frequência de amostragem (40 vezes a frequência do terceiro sinal)
ts = 1/fs;             % Intervalo de amostragem
t = 0 : ts : 1;        % Vetor de tempo de 0 a 1 segundo com passo de amostragem ts

% Gerando sinais de cosseno
x1_t = A1*cos(2*pi*f1*t + phi1);  % Sinal de cosseno para a primeira frequência
x2_t = A2*cos(2*pi*f2*t + phi2);  % Sinal de cosseno para a segunda frequência
x3_t = A3*cos(2*pi*f3*t + phi3);  % Sinal de cosseno para a terceira frequência

% Calculando a soma dos sinais
Soma = x1_t + x2_t + x3_t;         % Soma dos três sinais de cosseno

% Criando a primeira figura
figure; hold on;

% Plotando o primeiro sinal
subplot(3,1,1);                   % Cria um subplot de 3 linhas e 1 coluna, e seleciona o primeiro
plot(t, x1_t);                    % Plota o primeiro sinal de cosseno
ylim([-2 +2]);                    % Define os limites do eixo y para o gráfico
xlim([0 5*T1]);                   % Define os limites do eixo x para o gráfico (5 períodos do primeiro sinal)
ylabel('x_t');                    % Adiciona rótulo ao eixo y
xlabel('t(s)');                   % Adiciona rótulo ao eixo x
title('Cosseno de 2kHz');         % Adiciona título ao gráfico
legend('Acos(2*pi*f*t + phi)');   % Adiciona legenda ao gráfico
grid on;                         % Adiciona uma grade ao gráfico

% Plotando o segundo sinal
subplot(3,1,2);                   % Cria o segundo subplot
plot(t, x2_t);                    % Plota o segundo sinal de cosseno
ylim([-2 +2]);                    % Define os limites do eixo y para o gráfico
xlim([0 5*T2]);                   % Define os limites do eixo x para o gráfico (5 períodos do segundo sinal)
ylabel('x_t');                    % Adiciona rótulo ao eixo y
xlabel('t(s)');                   % Adiciona rótulo ao eixo x
title('Cosseno de 4kHz');         % Adiciona título ao gráfico
legend('Acos(2*pi*f*t + phi)');   % Adiciona legenda ao gráfico
grid on;                         % Adiciona uma grade ao gráfico

% Plotando o terceiro sinal
subplot(3,1,3);                   % Cria o terceiro subplot
plot(t, x3_t);                    % Plota o terceiro sinal de cosseno
ylim([-2 +2]);                    % Define os limites do eixo y para o gráfico
xlim([0 5*T3]);                   % Define os limites do eixo x para o gráfico (5 períodos do terceiro sinal)
ylabel('x_t');                    % Adiciona rótulo ao eixo y
xlabel('t(s)');                   % Adiciona rótulo ao eixo x
title('Cosseno de 8kHz');         % Adiciona título ao gráfico
legend('Acos(2*pi*f*t + phi)');   % Adiciona legenda ao gráfico
grid on;                         % Adiciona uma grade ao gráfico

% Criando a segunda figura
figure

% Plotando a soma dos sinais
plot(t, Soma);                    % Plota a soma dos três sinais de cosseno
ylim([-4 +4]);                    % Define os limites do eixo y para o gráfico da soma
xlim([0 5*T3]);                   % Define os limites do eixo x para o gráfico da soma (5 períodos do terceiro sinal)
ylabel('x_t');                    % Adiciona rótulo ao eixo y
xlabel('t(s)');                   % Adiciona rótulo ao eixo x
title('Soma dos Cossenos');       % Adiciona título ao gráfico da soma
legend('Acos(2*pi*f*t + phi)');   % Adiciona legenda ao gráfico da soma
grid on;                         % Adiciona uma grade ao gráfico da soma
