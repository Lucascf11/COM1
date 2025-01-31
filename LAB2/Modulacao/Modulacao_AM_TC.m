clc; close all; clear all;  % Limpa a janela de comando, fecha todas as janelas de figuras e remove todas as variáveis do workspace.

Fmodulante = 1000;              
Tmodulante = 1/Fmodulante;             
phimodulante = 0;              
Amodulante = 1;                

fportadora = 10000;              
Tportadora = 1/fportadora;              
phiportadora = 0;           
Aportadora = 1;                

% Definindo parâmetros de amostragem
fs = 40 * fportadora;           % Frequência de amostragem (40 vezes a frequência do terceiro sinal)
ts = 1/fs;             % Intervalo de amostragem
t = 0 : ts : 1;        % Vetor de tempo de 0 a 1 segundo com passo de amostragem ts

m = 1;
A0 = Amodulante / m;

% Domínio do tempo
m_t = Amodulante*cos(2*pi*Fmodulante*t + phimodulante);
c_t = Aportadora*cos(2*pi*fportadora*t + phiportadora);
s_t = (m_t .* c_t) + (A0 .* c_t);

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

%PLotando no domínio do tempo
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

%Plotando no domínio da frequência
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

figure(3)

subplot(2,1,1)
plot(t,s_t);
xlim([0 5*(1/Fmodulante)]);
ylabel('Amplitude');
xlabel('t(s)');
title('Sinal modulado no tempo');
grid on;
hold on;
plot(t,(m_t +A0));

subplot(2,1,2)
plot(f,X_Fmodulado);
xlim([-12000 12000]);
ylabel('Amplitude');
xlabel('f(Hz)');
title('Sinal modulado na frequência');
grid on;

