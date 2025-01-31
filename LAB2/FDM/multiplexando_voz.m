clc; close all; clear all;
pkg load signal;

% Fazendo leituras do sinal

[x1, fs1] = audioread('audio1.wav');
x1 = x1';
[x2, fs2] = audioread('audio2.wav');
x2 = x2';
[x3, fs3] = audioread('audio3.wav');
x3 = x3';

target_length = length(x2);

x1 = [x1, zeros(1, target_length - length(x1))];
x3 = [x3, zeros(1, target_length - length(x3))];

% Definindo o vetor de tempo
t1 = (0:length(x1)-1) / fs1; % Cria um vetor de tempo
ts1 = fs1/length(t1);

% Definindo o vetor frequencia
f1 = -fs1/2 : ts1  : (fs1/2) - ts1;


% Definindo portadoras
Aportadora = 1;
phiportadora = 0;
fportadora1 = 6000;  
fportadora2 = 10000;  
fportadora3 = 14000;   

c1_t = Aportadora*cos(2*pi*fportadora1*t1 + phiportadora);
c2_t = Aportadora*cos(2*pi*fportadora2*t1 + phiportadora);
c3_t = Aportadora*cos(2*pi*fportadora3*t1 + phiportadora);

% Colocando os sinais no dominio da frequência
X_F1 = fft(x1)/length(x1);
X_F1 = fftshift(X_F1);
X_F2 = fft(x2)/length(x2);
X_F2 = fftshift(X_F2);
X_F3 = fft(x3)/length(x3);
X_F3 = fftshift(X_F3);

C1_F = fft(c1_t)/length(c1_t);
C1_F = fftshift(C1_F);

C2_F = fft(c2_t)/length(c2_t);
C2_F = fftshift(C2_F);

C3_F = fft(c3_t)/length(c3_t);
C3_F = fftshift(C3_F);

% Deslocando os sinais na frequência
sinal1_deslocado1 = x1 .* c1_t;
sinal2_deslocado1 = x2 .* c2_t;
sinal3_deslocado1 = x3 .* c3_t;

X1_MODULADO_FREQ = fft(sinal1_deslocado1)/length(sinal1_deslocado1);
X1_MODULADO_FREQ = fftshift(X1_MODULADO_FREQ);
X2_MODULADO_FREQ = fft(sinal2_deslocado1)/length(sinal2_deslocado1);
X2_MODULADO_FREQ = fftshift(X2_MODULADO_FREQ);
X3_MODULADO_FREQ = fft(sinal3_deslocado1)/length(sinal3_deslocado1);
X3_MODULADO_FREQ = fftshift(X3_MODULADO_FREQ);


% FIltrando a banda superior dos sinais com passa faixas
passa_faixas1 = fir1(1000, [6000 9000]*2/fs1); 
passa_faixas2 = fir1(1000, [10000 13000]*2/fs1); 
passa_faixas3 = fir1(1000, [14000 17000]*2/fs1); 

sinal1_deslocado1_filtrado = filter(passa_faixas1, 1, sinal1_deslocado1); 
sinal2_deslocado1_filtrado = filter(passa_faixas2, 1, sinal2_deslocado1); 
sinal3_deslocado1_filtrado = filter(passa_faixas3, 1, sinal3_deslocado1); 

% Multiplexando os sinais
sinais_multiplexados = sinal1_deslocado1_filtrado + sinal2_deslocado1_filtrado + sinal3_deslocado1_filtrado;
XMULTIPLEXADO_FREQ = fft(sinais_multiplexados)/length(sinais_multiplexados);
XMULTIPLEXADO_FREQ = fftshift(XMULTIPLEXADO_FREQ);

% Tirando a soma dos sinais
sinal1_banda_superior = filter(passa_faixas1, 1, sinais_multiplexados); 
sinal2_banda_superior = filter(passa_faixas2, 1, sinais_multiplexados);
sinal3_banda_superior = filter(passa_faixas3, 1, sinais_multiplexados);

XSUPERIOR1_FREQ = fft(sinal1_banda_superior)/length(sinal1_banda_superior);
XSUPERIOR1_FREQ = fftshift(XSUPERIOR1_FREQ);
XSUPERIOR2_FREQ = fft(sinal2_banda_superior)/length(sinal2_banda_superior);
XSUPERIOR2_FREQ = fftshift(XSUPERIOR2_FREQ);
XSUPERIOR3_FREQ = fft(sinal3_banda_superior)/length(sinal3_banda_superior);
XSUPERIOR3_FREQ = fftshift(XSUPERIOR3_FREQ);

% Passando os sinais pelos osciladores novamente

sinal1_deslocado2 = sinal1_deslocado1 .* c1_t;
sinal2_deslocado2 = sinal2_deslocado1 .* c2_t;
sinal3_deslocado2 = sinal3_deslocado1 .* c3_t;

X1_MODULADO_FREQ2 = fft(sinal1_deslocado2)/length(sinal1_deslocado2);
X1_MODULADO_FREQ2 = fftshift(X1_MODULADO_FREQ2);
X2_MODULADO_FREQ2 = fft(sinal2_deslocado2)/length(sinal2_deslocado2);
X2_MODULADO_FREQ2 = fftshift(X2_MODULADO_FREQ2);
X3_MODULADO_FREQ2 = fft(sinal3_deslocado2)/length(sinal3_deslocado2);
X3_MODULADO_FREQ2 = fftshift(X3_MODULADO_FREQ2);

% Realizando a filtragem passa baixas e finalizando a demodulação
passa_baixa = fir1(1000, (3000*2)/fs1); 

sinal1_demodulado = filter(passa_baixa,1,sinal1_deslocado2);
sinal2_demodulado = filter(passa_baixa,1,sinal2_deslocado2);
sinal3_demodulado = filter(passa_baixa,1,sinal3_deslocado2);

X1_DEMODULADO_FREQ = fft(sinal1_demodulado)/length(sinal1_demodulado);
X1_DEMODULADO_FREQ = fftshift(X1_DEMODULADO_FREQ);
X2_DEMODULADO_FREQ = fft(sinal2_demodulado)/length(sinal2_demodulado);
X2_DEMODULADO_FREQ = fftshift(X2_DEMODULADO_FREQ);
X3_DEMODULADO_FREQ = fft(sinal3_demodulado)/length(sinal3_demodulado);
X3_DEMODULADO_FREQ = fftshift(X3_DEMODULADO_FREQ);


%--------------------------------------------------------------------------------------------------------
%PLOTAGEM DOS GRÁFICOS
%--------------------------------------------------------------------------------------------------------


%Plotando os sinais iniciais no tempo
# figure(1); hold on;

# subplot(3,1,1)
# plot(t1,x1);
# ylabel('m_t');
# xlabel('t(s)');
# title('Sinal m(t)');
# grid on;

# subplot(3,1,2)
# plot(t1,x2);
# ylabel('m_t');
# xlabel('t(s)');
# title('Sinal m(t)');
# grid on;

# subplot(3,1,3)
# plot(t1,x3);
# ylabel('m_t');
# xlabel('t(s)');
# title('Sinal m(t)');
# grid on;

figure(2); hold on;

subplot(3,1,1)
plot(f1,abs(X_F1));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 1');
grid on;

subplot(3,1,2)
plot(f1,abs(X_F2));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 2');
grid on;

subplot(3,1,3)
plot(f1,abs(X_F3));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 3');
grid on;

#  figure(3); hold on;

#  subplot(3,1,1)
#  plot(f1,abs(C1_F));
#  xlim([-15000 15000]);
#  ylabel('m_t');
#  xlabel('t(s)');
#  title('Sinal m(t)');
#  grid on;

#  subplot(3,1,2)
#  plot(f1,abs(C2_F));
#  xlim([-15000 15000]);
#  ylabel('m_t');
#  xlabel('t(s)');
#  title('Sinal m(t)');
#  grid on;

#  subplot(3,1,3)
#  plot(f1,abs(C3_F));
#  xlim([-15000 15000]);
#  ylabel('m_t');
#  xlabel('t(s)');
#  title('Sinal m(t)');
#  grid on;

% Plotando os sinais deslocados na frequência

 figure(4); hold on;

 subplot(3,1,1)
 plot(f1,abs(X1_MODULADO_FREQ));
 xlim([-9000 9000]);
 ylabel('Amplitude');
 xlabel('Frequência (Hz)');
 title('Sinal de voz 1 descolado');
 grid on;

 subplot(3,1,2)
 plot(f1,abs(X2_MODULADO_FREQ));
 xlim([-13000 13000]);
 ylabel('Amplitude');
 xlabel('Frequência (Hz)');
 title('Sinal de voz 2 deslocado');
 grid on;

 subplot(3,1,3)
 plot(f1,abs(X3_MODULADO_FREQ));
 xlim([-17000 17000]);
 ylabel('Amplitude');
 xlabel('Frequência (Hz)');
 title('Sinal de voz 3 deslocado');
 grid on;

figure (5); hold on;
plot(f1,abs(XMULTIPLEXADO_FREQ));
xlim([-18000 18000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinais de voz filtrados e multiplexados');
grid on;

figure (6); hold on;

subplot(3,1,1)
plot(f1,abs(XSUPERIOR1_FREQ));
xlim([-9000 9000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 1 separado');
grid on;

subplot(3,1,2)
plot(f1,abs(XSUPERIOR2_FREQ));
xlim([-13000 13000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 2 separado');
grid on;

subplot(3,1,3)
plot(f1,abs(XSUPERIOR3_FREQ));
xlim([-17000 17000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 3 separado');

figure (7); hold on;

subplot(3,1,1)
plot(f1,abs(X1_MODULADO_FREQ2));
xlim([-15000 15000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 1 predemodulado');
grid on;

subplot(3,1,2)
plot(f1,abs(X2_MODULADO_FREQ2));
xlim([-21000 21000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 2 predemodulado');
grid on;

subplot(3,1,3)
plot(f1,abs(X3_MODULADO_FREQ2));
xlim([-27000 27000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 3 predemodulado');
grid on;

figure (8); hold on;

subplot(3,1,1)
plot(f1,abs(X1_DEMODULADO_FREQ));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 1 totalmente recuperado');
grid on;

subplot(3,1,2)
plot(f1,abs(X2_DEMODULADO_FREQ));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 2 totalmente recuperado');
grid on;

subplot(3,1,3)
plot(f1,abs(X3_DEMODULADO_FREQ));
xlim([-5000 5000]);
ylabel('Amplitude');
xlabel('Frequência (Hz)');
title('Sinal de voz 3 totalmente recuperado');
grid on;


