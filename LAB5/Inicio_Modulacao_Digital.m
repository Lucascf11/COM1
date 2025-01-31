clear all; close all; clc;
pkg load signal;

% Conceituando o cosseno

fc = 50;                        % Frequência do sinal (1000 Hz)
T = 1/fc;                       % Período do sinal
phi = 0;                        % Fase do sinal (0 radianos)
A = 3;                          % Amplitude do sinal
amostras_N = 20;                % Quantidade de amostras por período da portadora
periodos_N = 5;                 % Quantidade de períodos por pulso
N = amostras_N * periodos_N;    % Quantiadde de amostras por pulso
M = 2;

% Fazendo o RZ
info = [0 1 0 1 1 0 0 1 0 1];
info_up = upsample(info,N);
filtroRZ = ones(1,N);
info_RZ = filter(filtroRZ,1,info_up) * A;

% Definindo parâmetros de amostragem e criando o vetor tempo

fs = amostras_N * fc;           % Frequência de amostragem (40 vezes a frequência do sinal)
ts = 1/fs;
t = (0:length(info_RZ)-1) * ts;



% Criando os sinais modulados
s_t_psk = A * cos(2 * pi * fc * t + (2 * pi * info_RZ) / M);
s_t_fsk = A * cos(2 * pi * fc * info_RZ .* t);
s_t_ask = A * info_RZ .* cos(2 * pi * fc * t);

% Fazendo os plots
figure(1);

subplot(311)
plot(t, info_RZ, 'b');
hold on;
plot(t, s_t_psk, 'r');
xlim([0, max(t)]);
ylim([-3*A, 3*A]);
title('Fazendo PSK');
grid on;

subplot(312)
plot(t, info_RZ, 'b');
hold on;
plot(t, s_t_fsk, 'r');
xlim([0, max(t)]);
ylim([-3*A, 3*A]);
title('Fazendo FSK');
grid on;

subplot(313)
plot(t, info_RZ, 'b');
hold on;
plot(t, s_t_ask, 'r');
xlim([0, max(t)]);
ylim([-3*A, 3*A]);
title('Fazendo ASK');
grid on;
