clc; close all; clear all;
pkg load signal;

% Parâmetros do primeiro sinal
f1 = 1000;
phi1 = 0; 
A1 = 6;

% Parâmetros do segundo sinal
f2 = 3000;
phi2 = 0;
A2 = 2;

% Parâmetros do terceiro sinal
f3 = 5000;
phi3 = 0;
A3 = 4;

% Amostragem
fs = 40 * f3;
ts = 1/fs;
t = 0 : ts : 1;

% Montando os sinais
x1_t = A1*sin(2*pi*f1*t + phi1);
x2_t = A2*sin(2*pi*f2*t + phi2);
x3_t = A3*sin(2*pi*f3*t + phi3);

% Soma dos senos:
s_t = x1_t + x2_t + x3_t;

% Plotando os sinais no eixo do tempo
figure; hold on; 

subplot(4,1,1);
plot(t,x1_t);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude (Volts)');
xlabel('t(s)');
title('Sinal x1 em função do tempo');
grid on;

subplot(4,1,2);
plot(t,x2_t);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude (Volts)');
xlabel('t(s)');
title('Sinal x2 em função do tempo');
grid on;

subplot(4,1,3);
plot(t,x3_t);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude (Volts)');
xlabel('t(s)');
title('Sinal x3 em função do tempo');
grid on;

subplot(4,1,4);
plot(t,s_t);
ylim([-12 12]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude (Volts)');
xlabel('t(s)');
title('Sinal s em função do tempo');
grid on;

% Vetor da frequência:
df = length(t) / (fs+1);
f = -fs/2 : df : fs/2;

% Colocando os sinais no domínio da frequência

X_f1 = fft(x1_t)/length(x1_t);
X_f1 = fftshift(X_f1);

X_f2 = fft(x2_t)/length(x2_t);
X_f2 = fftshift(X_f2);

X_f3 = fft(x3_t)/length(x3_t);
X_f3 = fftshift(X_f3);

X_s = fft(s_t)/length(s_t);
X_s = fftshift(X_s);


% Plotando os sinais no domínio da frequência
figure;

subplot(4,1,1);
plot(f,abs(X_f1));
xlim([-6000 6000]);
ylim([0 4]);
ylabel('Amplitude (Volts)');
xlabel('f(Hz)');
title('Sinal x1 em função da frequência');
grid on;

subplot(4,1,2);
plot(f,abs(X_f2));
xlim([-6000 6000]);
ylim([0 4]);
ylabel('Amplitude (Volts)');
xlabel('f(Hz)');
title('Sinal x2 em função da frequência');
grid on;

subplot(4,1,3);
plot(f,abs(X_f3));
xlim([-6000 6000]);
ylim([0 4]);
ylabel('Amplitude (Volts)');
xlabel('f(Hz)');
title('Sinal x3 em função da frequência');
grid on;

subplot(4,1,4);
plot(f,abs(X_s));
xlim([-6000 6000]);
ylim([0 4]);
ylabel('Amplitude (Volts)');
xlabel('f(Hz)');
title('Sinal s em função da frequência');
grid on;

% Potência média de s(t)
Pmeds = (1/length(s_t)) * ((norm(s_t)).^2)

% densidade espectral de potencia
[densidade_espectral, frequencias] = pwelch(s_t, [], [], [], fs, 'shift', 'semilogy');

figure; hold on; grid on;
plot(frequencias, 10*log10(densidade_espectral));
xlim([-7000 7000]);
xlabel('Frequência (Hz)');
ylabel('Densidade espectral de potência (dB/Hz)');
title('Densidade Espectral de Potência usando pwelch');
