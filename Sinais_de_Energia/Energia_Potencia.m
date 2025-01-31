clc; close all; clear all;

f1 = 100;                       % Frequência do sinal (1000 Hz)
f2 = 200;
f3 = 300;
T1 = 1/f1;                      % Período do sinal
fs = 40 * f3;                   % Frequência de amostragem (40 vezes a frequência do sinal)
ts = 1/fs;                      % Intervalo de amostragem
t = 0 : ts : 1;                 % Vetor de tempo de 0 até 1 segundo com passo de amostragem ts
phi = 0;                        % Fase do sinal (0 radianos)
A = 1;                          % Amplitude do sinal

xa_t = 10*cos(2*pi*f1*t);
xb_t = cos(2*pi*f2*t);
xc_t = 4*cos(2*pi*f3*t);
x1_t = xa_t + xb_t + xc_t; % x1(t) = 10*cos(100t) + cos(200t) + 4*cos(300t)
x2_t = 2 + 6*cos(100*t); % x2(t) = 2 + 6*cos(200t)
x3_t = 10*cos(2*pi*f1*t) + 5*cos(2*pi*f2*t); %x3(t) = 10*cos(100t) + 5*cos(200t)


%% Sinal de potência (Medida temporal)
x1p_t = 1/length(t) * sum(x1_t.^2)
x2p_t = 1/length(t) * sum(x2_t.^2)
x3p_t = 1/length(t) * sum(x3_t.^2)

% Medida estatística
x2m = mean(x2_t)
x2var = var(x2_t)

figure; hold on; grid on;
%plot(t,x1p_t);
%xlim([0 5*T]);



