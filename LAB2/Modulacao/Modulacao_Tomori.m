clc; close all; clear all;  % Limpa a janela de comando, fecha todas as janelas de figuras e remove todas as variáveis do workspace.

% Definindo parâmetros para o primeiro sinal
Fmodulante = 1000;              % Frequência do primeiro sinal (2000 Hz)
Tmodulante = 1/Fmodulante;              % Período do primeiro sinal
phimodulante = 0;               % Fase do primeiro sinal (0 radianos)
Amodulante = 1;                 % Amplitude do primeiro sinal

% Definindo parâmetros para o segundo sinal
fportadora = 10000;              % Frequência do segundo sinal (4000 Hz, que é o dobro da primeira frequência)
Tportadora = 1/fportadora;              % Período do segundo sinal
phiportadora = 0;           % Fase do segundo sinal (π/2 radianos)
Aportadora = 1;                 % Amplitude do segundo sinal

% Definindo parâmetros de amostragem
fs = 40 * fportadora;           % Frequência de amostragem (40 vezes a frequência do terceiro sinal)
ts = 1/fs;             % Intervalo de amostragem
t = 0 : ts : 1;        % Vetor de tempo de 0 a 1 segundo com passo de amostragem ts


% Domínio do tempo
m_t = Amodulante*cos(2*pi*Fmodulante*t + phimodulante);
c_t = Aportadora*cos(2*pi*fportadora*t + phiportadora);
s_t = m_t .* c_t;

% Vetor da frequência:
df = length(t) / (fs+1);
f = -fs/2 : df : fs/2;

% Domínio da frequência
X_Fmodulante = fft(m_t)/length(m_t);
X_Fmodulante = fftshift(X_Fmodulante);

X_fportadora = fft(c_t)/length(c_t);
X_fportadora = fftshift(X_fportadora);

X_Fmodulado = fft(s_t)/length(s_t);
X_Fmodulado = fftshift(X_Fmodulado);

%Plotando o modulante
figure(1);

subplot(2,1,1)
plot(t,m_t);
xlim([0 5*(1/Fmodulante)]);
ylabel('Amplitude');
xlabel('t(s)');
title('Sinal Modulante no Tempo');
grid on;

subplot(2,1,2)
plot(f,X_Fmodulante);
xlim([-12000 12000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal modulante na frequência');
grid on;

%Plotando a portadora
figure(2)

subplot(2,1,1)
plot(t,c_t);
xlim([0 5*(1/Fmodulante)]);
ylabel('Amplitude');
xlabel('t(s)');
title('Sinal da portadora no tempo');
grid on;

subplot(2,1,2)
plot(f,X_fportadora);
xlim([-12000 12000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal da portadora na frequência');
grid on;

% Plotando o modulado
figure(3)

subplot(2,1,1)
plot(t,s_t);
xlim([0 5*(1/Fmodulante)]);
ylabel('Amplitude');
xlabel('t(s)');
title('Sinal modulado no tempo');
grid on;

subplot(2,1,2)
plot(f,X_Fmodulado);
xlim([-12000 12000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal modulado na frequência');
grid on;


% Multiplicando  o sinal pelo cosseno
r_t = s_t .* c_t;

% Passando para a frequência
X_Fdemodulado = fft(r_t)/length(r_t);
X_Fdemodulado = fftshift(X_Fdemodulado);

% Retornando o sinal para a origem
figure;
subplot(2,1,1)
plot(f,X_fportadora);
xlim([-24000 24000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal da portadora na frequência');
grid on;

subplot(2,1,2)
plot(f,X_Fdemodulado);
xlim([-24000 24000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal modulado movido novamente pelo Cosseno');
grid on;

% Filtragem Passa baixa
% Filtro passa baixa
filtro_passa_baixa = [zeros(1,199000) ones(1,2001), zeros(1,199000)];
sinal_filtrado1 = filtro_passa_baixa .* X_Fdemodulado;

sinal_filtrado_tempo = ifftshift(sinal_filtrado1);
sinal_filtrado_tempo = ifft(sinal_filtrado_tempo) * length(s_t);

% Plotando o sinal demodulado
figure(5)
subplot(2,1,1)
plot(f,sinal_filtrado1);
xlim([-12000 12000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal demodulado na frequência');
grid on;

subplot(2,1,2)
plot(t,sinal_filtrado_tempo);
xlim([0 5*(1/Fmodulante)]);
ylabel('Amplitude');
xlabel('t(s)');
title('Sinal demodulado no tempo');
grid on;



