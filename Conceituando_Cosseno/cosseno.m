clc; close all; clear all;

f1 = 100;                       % Frequência do sinal (1000 Hz)
f2 = 200;
f3 = 300;
T = 1/f1;                        % Período do sinal
fs = 40 * f3;                    % Frequência de amostragem (40 vezes a frequência do sinal)
ts = 1/fs;                      % Intervalo de amostragem
t = 0 : ts : 1;                 % Vetor de tempo de 0 até 1 segundo com passo de amostragem ts
phi = 0;                        % Fase do sinal (0 radianos)
A = 1;                          % Amplitude do sinal

xa_t = 10*cos(2*pi*f1*t);
xb_t = cos(2*pi*f2*t);
xc_t = 4*cos(2*pi*f3*t);
x_t = xa_t + xb_t + xc_t;



figure; hold on;
subplot(3,1,1);
plot(t,xa_t)
xlim([0 5*T]);

subplot(3,1,2);
plot(t,xb_t)
xlim([0 5*T]);

subplot(3,1,3);
plot(t,xc_t)
xlim([0 5*T]);

X_f = fft(x_t) / length(x_t);  % Calcula a Transformada de Fourier do sinal x_t e normaliza pelo comprimento do vetor x_t
X_f = fftshift(X_f);           % Move o zero da frequência para o centro do espectro de frequência

df = length(t) / (fs+1);           % Calcula a resolução em frequência
f = -fs/2 : df : fs/2;         % Cria o vetor de frequências do espectro

figure; hold on;
subplot(2,1,1)
plot(t,x_t);
xlim([0 5*T]);
title('Domínio do Tempo')

subplot(2,1,2)
plot(f,X_f);
xlim([-400 400]);
ylim([0 7])
title('Domínio da Frequência')



