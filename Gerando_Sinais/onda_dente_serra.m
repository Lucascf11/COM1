clc; close all; clear all;

N = 125;                         % Número de harmônicos a serem usados para aproximar a onda quadrada
f = 1_000;                       % Frequência do sinal
T = 1/f;                        % Período do sinal        
fs = 40 * (f*N);
ts = 1/fs;                      % Intervalo de amostragem
t = 0 : ts : 1;               % Vetor de tempo de 0 até 5 períodos do sinal com passo de amostragem ts
phi = 0;                        % Fase do sinal (0 radianos)
A = 1;                          % Amplitude do sinal

x_t = zeros(size(t));           % Inicializa o vetor x_t com zeros, com o mesmo tamanho do vetor t

% Calcula a soma das componentes harmônicas ímpares para formar a onda quadrada
for n = 1:2:N                   % Loop para somar as componentes harmônicas ímpares (1, 3, 5, ..., N)
   x_t += A*(4/(pi*n))*cos(2*pi*n*f*t); % Adiciona a n-ésima componente harmônica ao vetor x_t
end

x_t = x_t / max(abs(x_t));     % Normaliza o vetor x_t para que o valor máximo absoluto seja 1

figure                         % Cria uma nova figura para o gráfico
plot(t, x_t);                  % Plota o vetor x_t em função do tempo t
ylim([-1.1 +1.1]);             % Define os limites do eixo y para o gráfico
xlim([0 10*T]);                 % Define os limites do eixo x para o gráfico (5 períodos do sinal)
ylabel('x_t');                 % Adiciona rótulo ao eixo y
xlabel('t(s)');                % Adiciona rótulo ao eixo x
title('Onda quadrada');        % Adiciona título ao gráfico
grid on;                       % Adiciona uma grade ao gráfico
