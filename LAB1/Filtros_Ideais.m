clc; close all; clear all;

% Parâmetros do primeiro sinal
f1 = 1000;
phi1 = 0; 
A1 = 5;

% Parâmetros do segundo sinal
f2 = 3000;
phi2 = 0;
A2 = 5/3;

% Parâmetros do terceiro sinal
f3 = 5000;
phi3 = 0;
A3 = 1;

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
N = 40;
A = 5;

info = [0 1 1 1 0 0 1 0 0 1];
info_RZ = info * A;
info_RZ_up = upsample(info_RZ,N);
filtroRZ = ones(1,N);
sinalRZ =filter(filtroRZ, 1, info_RZ_up);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude(V)');
xlabel('t(s)');
title('Sinal x1(t)');
grid on;

subplot(4,1,2);
plot(t,x2_t);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude(V)');
xlabel('t(s)');
title('Sinal x2(t)');
grid on;

subplot(4,1,3);
plot(t,x3_t);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude(V)');
xlabel('t(s)');
title('Sinal x3(t)');
grid on;

subplot(4,1,4);
plot(t,s_t);
ylim([-7 7]);
xlim([0 5*(1/f1)]);
ylabel('Amplitude(V)');
xlabel('t(s)');
title('Sinal s(t)');
grid on;

% Vetor da frequência:
df = length(t) / (fs+1);
f = -fs/2 : df : fs/2;

% Colocando os sinais no domínio da frequência

X1_f = fft(x1_t)/length(x1_t);
X1_f = fftshift(X1_f);

X2_f = fft(x2_t)/length(x2_t);
X2_f = fftshift(X2_f);

X3_f = fft(x3_t)/length(x3_t);
X3_f = fftshift(X3_f);

Xs_f = fft(s_t)/length(s_t);
Xs_f = fftshift(Xs_f);



% Plotando os sinais no domínio da frequência
figure;

subplot(4,1,1);
plot(f,abs(X1_f));
xlim([-6000 6000]);
ylim([0 3]);
ylabel('Amplitude(V)');
xlabel('f(Hz)');
title('Sinal x1 no domínio do tempo');
grid on;

subplot(4,1,2);
plot(f,abs(X2_f));
xlim([-6000 6000]);
ylim([0 3]);
ylabel('Amplitude(V)');
xlabel('f(Hz)');
title('Sinal x2 no domínio do tempo');
grid on;

subplot(4,1,3);
plot(f,abs(X3_f));
xlim([-6000 6000]);
ylim([0 3]);
ylabel('Amplitude(V)');
xlabel('f(Hz)');
title('Sinal x3 no domínio do tempo');
grid on;

subplot(4,1,4);
plot(f,abs(Xs_f));
xlim([-6000 6000]);
ylim([0 3]);
ylabel('Amplitude(V)');
xlabel('f(Hz)');
title('Sinal s no domínio do tempo');
grid on;

% Filtro passa baixa
frequencia_corte1 = 2000;
filtro_passa_baixa = [zeros(1,98000) ones(1,4001), zeros(1,98000)];
sinal_filtrado1_frequencia = filtro_passa_baixa .* Xs_f;
sinal_filtrado1_tempo = ifftshift(sinal_filtrado1_frequencia);
sinal_filtrado1_tempo = ifft(sinal_filtrado1_tempo) * length(s_t);

%Filtro passa alta
frequencia_corte2 = 4000;
filtro_passa_alta = [ones(1,96000), zeros(1,8001), ones(1,96000)];
sinal_filtrado2_frequencia = filtro_passa_alta .* Xs_f;
sinal_filtrado2_tempo = ifftshift(sinal_filtrado2_frequencia);
sinal_filtrado2_tempo = ifft(sinal_filtrado2_tempo) * length(s_t);


%Filtro passa faixa
filtro_passa_faixa = [zeros(1,96000),ones(1,2000),zeros(1,4001),ones(1,2000),zeros(1,96000)];
sinal_filtrado3_frequencia = filtro_passa_faixa .* Xs_f;
sinal_filtrado3_tempo = ifftshift(sinal_filtrado3_frequencia);
sinal_filtrado3_tempo = ifft(sinal_filtrado3_tempo) * length(s_t);


% Plotando as respostas em frequência

figure 

subplot(3,1,1)
plot(f,filtro_passa_baixa);
xlim([-6000 6000]);
ylim([0 2]);
xlabel('f(Hz)')
ylabel('Função de Transferência')
title('Resposta em frequência passa baixa')
grid on;

subplot(3,1,2)
plot(f,filtro_passa_alta);
xlim([-6000 6000]);
ylim([0 2]);
xlabel('f(Hz)')
ylabel('Função de Transferência')
title('Resposta em frequência passa alta')
grid on;

subplot(3,1,3)
plot(f,filtro_passa_faixa);
xlim([-6000 6000]);
ylim([0 2]);
xlabel('f(Hz)')
ylabel('Função de Transferência')
title('Resposta em frequência passa faixa')
grid on;


% Plotando os sinais filtrados
figure

subplot(4,2,1)
plot(f,abs(Xs_f));
xlim([-6000 6000]);
ylim([0 3]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s antes de filtrar na frequência')
grid on;

subplot(4,2,2)
plot(t,s_t);
ylim([-7 7]);
xlim([0 5*(1/f1)]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s antes de filtrar no tempo')
grid on;

subplot(4,2,3)
plot(f,abs(sinal_filtrado1_frequencia));
xlim([-6000 6000]);
ylim([0 3]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa baixa na frequência')
grid on;

subplot(4,2,4)
plot(t,sinal_filtrado1_tempo);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa baixa no tempo')
grid on;

subplot(4,2,5)
plot(f,abs(sinal_filtrado2_frequencia));
xlim([-6000 6000]);
ylim([0 3]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa altas na frequência')
grid on;

subplot(4,2,6)
plot(t,sinal_filtrado2_tempo);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa altas no tempo')
grid on;

subplot(4,2,7)
plot(f,abs(sinal_filtrado3_frequencia));
xlim([-6000 6000]);
ylim([0 3]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa faixas na frequência')
grid on;

subplot(4,2,8)
plot(t,sinal_filtrado3_tempo);
ylim([-8 8]);
xlim([0 5*(1/f1)]);
xlabel('f(Hz)')
ylabel('Amplitude(V)')
title('Sinal s filtrado com passa faixas no tempo')
grid on;