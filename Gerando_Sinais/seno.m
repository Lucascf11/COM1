clc;                            % Limpa a janela de comandos
close all;                       % Fecha todas as figuras abertas
clear all;                       % Limpa todas as variáveis do workspace

f = 1_000;                       % Frequência do sinal (1000 Hz)
T = 1/f;                        % Período do sinal
fs = 40 * f;                    % Frequência de amostragem (40 vezes a frequência do sinal)
ts = 1/fs;                      % Intervalo de amostragem
t = 0 : ts : 1;                 % Vetor de tempo de 0 até 1 segundo com passo de amostragem ts
phi = 0;                        % Fase do sinal (0 radianos)
A = 1;                          % Amplitude do sinal

x_t = A*sin(2*pi*f*t + phi);   % Gera o sinal senoidal com amplitude A, frequência f, fase phi e vetor de tempo t

figure                         % Cria uma nova figura para o gráfico
plot(t, x_t);                  % Plota o sinal x_t em função do tempo t
ylim([-2 +2]);                 % Define os limites do eixo y para o gráfico
xlim([0 5*T]);                 % Define os limites do eixo x para o gráfico (5 períodos do sinal)
ylabel('x_t');                 % Adiciona rótulo ao eixo y
xlabel('t(s)');                % Adiciona rótulo ao eixo x
title('x em função do tempo t'); % Adiciona título ao gráfico
legend('Asin(2*pi*f*t + phi)'); % Adiciona uma legenda ao gráfico
grid on;                       % Adiciona uma grade ao gráfico

% Cálculo da Transformada de Fourier
X_f = fft(x_t) / length(x_t);  % Calcula a Transformada de Fourier do sinal x_t e normaliza pelo comprimento do vetor x_t
X_f = fftshift(X_f);           % Move o zero da frequência para o centro do espectro de frequência

% Criação do vetor de frequências para o gráfico
df = length(t) / (fs+1);           % Calcula a resolução em frequência
f = -fs/2 : df : fs/2;         % Cria o vetor de frequências do espectro

figure;                        % Cria uma nova figura para o gráfico
plot(f, abs(X_f));             % Plota o módulo da Transformada de Fourier em função da frequência f
ylabel('X{F}');                % Adiciona rótulo ao eixo y
xlabel('f(Hz)');               % Adiciona rótulo ao eixo x
title('x em função do tempo f'); % Adiciona título ao gráfico
grid on;                       % Adiciona uma grade ao gráfico
