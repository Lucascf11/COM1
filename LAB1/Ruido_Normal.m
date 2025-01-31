clc; clear all; close all;

pkg load statistics;
pkg load signal;

% 1. Gerar vetor de ruído com distribuição normal (randn) para 1 segundo
fs = 10000;  % Frequência de amostragem 10 kHz
t = 0:1/fs:1-1/fs;  % Vetor de tempo de 1 segundo
ruido = randn(size(t));  % Geração do ruído Gaussiano

% 2. Plotar o histograma do ruído
figure;
hist(ruido, 50);  % 50 bins para observar melhor a distribuição
title('Histograma do Ruído Gaussiano');
xlabel('Amplitude');
ylabel('Frequência');

% 3. Plotar o ruído no domínio do tempo e da frequência com shift
figure;
subplot(2,1,1);
plot(t, ruido);
title('Ruído no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
f = linspace(-fs/2, fs/2, length(ruido));  % Frequências centradas em zero
Ruido_Freq = fftshift(abs(fft(ruido)));  % FFT do ruído com shift
plot(f, Ruido_Freq);
title('Ruído no Domínio da Frequência (com shift)');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% 4. Autocorrelação do ruído usando 'xcorr'
figure;
autocorr = xcorr(ruido, 'normalized');
lag = (-length(ruido)+1:length(ruido)-1)/fs;
plot(lag, autocorr);
title('Função de Autocorrelação do Ruído');
xlabel('Defasagem (s)');
ylabel('Autocorrelação');

% 5. Filtragem passa-baixa com filtro FIR
filtro = fir1(50, (1000*2)/fs);  % Filtro FIR de ordem 50 com cutoff de 1000 Hz
ruido_filtrado = filter(filtro, 1, ruido);  % Aplicação do filtro no ruído

% fir1(50, [6000 9000]*2/fs)

% Visualizar a resposta em frequência do filtro
figure;
freqz(filtro, 1, 1024, fs);
title('Resposta em Frequência do Filtro Passa-baixa');

% 6. Plote o sinal filtrado no domínio do tempo e da frequência com shift
figure;
subplot(2,1,1);
plot(t, ruido_filtrado);
title('Sinal Filtrado no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
Ruido_Filtrado_Freq = fftshift(abs(fft(ruido_filtrado)));  % FFT com shift
plot(f, Ruido_Filtrado_Freq);
title('Sinal Filtrado no Domínio da Frequência (com shift)');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Plotar o histograma do sinal filtrado
figure;
hist(ruido_filtrado, 50);
title('Histograma do Sinal Filtrado');
xlabel('Amplitude');
ylabel('Frequência');

variancia_sem_filtar = var(ruido)
variancia_pos_fitrar = var(ruido_filtrado)