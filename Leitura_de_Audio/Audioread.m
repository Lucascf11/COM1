clc; close all; clear all;
pkg load signal;

[x, fs] = audioread('Cafe.ogg');

t = (0:length(x)-1) / fs; % Cria um vetor de tempo
ts = fs/length(t);

% Definindo parâmetros para o segundo sinal
fportadora = 5000;              % Frequência do segundo sinal (4000 Hz, que é o dobro da primeira frequência)
Tportadora = 1/fportadora;              % Período do segundo sinal
phiportadora = 0;           % Fase do segundo sinal (π/2 radianos)
Aportadora = 1;                 % Amplitude do segundo sinal

% Domínio do tempo
c_t = Aportadora*cos(2*pi*fportadora*t + phiportadora);
s_t = transpose(x) .* c_t;

% Vetor da frequência:
f = -fs/2 : ts  : (fs/2) - ts;



% Domínio da frequência
X_Fmodulante = fft(x)/length(x);
X_Fmodulante = fftshift(X_Fmodulante);

X_fportadora = fft(c_t)/length(c_t);
X_fportadora = fftshift(X_fportadora);

X_Fmodulado = fft(s_t)/length(s_t);
X_Fmodulado = fftshift(X_Fmodulado);


figure(1)
plot(t, x);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Sinal de Áudio');

figure(2)
plot(f,abs(X_Fmodulante));

figure(3)
plot(f,abs(X_fportadora));

figure(4)
plot(f,abs(X_Fmodulado));

% Processo de demodulação:





