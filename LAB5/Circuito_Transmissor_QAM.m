close all; clear all; clc;
pkg load signal;
pkg load communications;

M = 16;
info = [1 0 1 1 0 0 0 0 0 1 1 0 0 0 1 0];
bits = log2(M);
fc = 10;

periodos_pulso_NRZ = 4;
amostras_periodo = 10;
N = periodos_pulso_NRZ * amostras_periodo;
A = 1;

Rb = M;
Rs = Rb/bits;

fs = Rs * N;
ts = 1/fs;
t = [0:ts:1-ts];


% Passando pelo conversor decimal
info_DEC = bi2de(reshape(info, bits, [])', 'left-msb')';

% Realizando modulação QAM em 16-QAM
sinalQAM = qammod(info_DEC,M);

% Separando parte real (inphase) e imagíaria (quadratura)
sinalQAM_real = real(sinalQAM);
sinalQAM_imag = imag(sinalQAM);

% Fazendo os 4 PAMs
sinalQAM_real_up = upsample(sinalQAM_real,N);
sinalQAM_imag_up = upsample(sinalQAM_imag,N);
filtroRZ = ones(1,N);

sinalQAM_real_RZ = filter(filtroRZ,1,sinalQAM_real_up);
sinalQAM_imag_RZ = filter(filtroRZ,1,sinalQAM_imag_up);

% Fazendo os multiplicadores
cosseno = A*cos(2 * pi * fc * t);
seno = A*sin(2 * pi * fc * t);

% Realizando as multiplicados
sinalQAM_real_RZ_deslocado = cosseno .* sinalQAM_real_RZ;
sinalQAM_imag_RZ_deslocado = seno .* sinalQAM_imag_RZ;

sinal_final = sinalQAM_real_RZ_deslocado - sinalQAM_imag_RZ_deslocado;

% Plots 


figure(1)
% Plot do RZ do real
subplot(211)
plot(t, sinalQAM_real_RZ);
title('RZ Real');
xlabel('Tempo amostral'); ylim('Amplitude');
ylim([-4 4]);
% Plot do RZ do imaginário
subplot(212)
plot(t, sinalQAM_imag_RZ);
title('RZ Imaginário');
xlabel('Tempo amostral'); ylim('Amplitude');
ylim([-4 4]);

figure(2)
plot(t,sinal_final);
title('sinal final');
xlabel('Tempo amostral'); ylim('Amplitude');










