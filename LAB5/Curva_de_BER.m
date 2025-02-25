clear all
close all
clc

pkg load signal;
pkg load communications;

function [sinal_normalizado] = modnorm(sinal_QAM)
  % Calcula a energia média dos símbolos da constelação
  energia_media = mean(abs(sinal_QAM).^2);
  
  % Calcula o fator de normalização para energia unitária
  fator_normalizacao = 1 / sqrt(energia_media);
  
  % Normaliza o sinal QAM
  sinal_normalizado = sinal_QAM * fator_normalizacao;
end  

LIMIT_SNR = 40;

M = 64;
Simbolos = 100000;
info = randint(1,Simbolos,M); % Gerando informação binária aleatória de M bits
info = info(:);
sinal_QAM = qammod(info,M);
sinal_QAM_normalizado = modnorm(sinal_QAM);


% Função personalizada para calcular erros de bit
for SNR = 0:LIMIT_SNR
    SNR
    sinal_QAM_ruido = awgn(sinal_QAM_normalizado, SNR, 'measured');
    info_demod = qamdemod(sinal_QAM_ruido,M);
    numErrors(SNR+1) = sum(info ~= info_demod); % Conta os símbolos errados
    taxa(SNR+1) = numErrors(SNR+1) / Simbolos; % Calcula a SER

end

figure(1); 
hold on; % Mantém o gráfico atual para adicionar novos dados

semilogy(0:LIMIT_SNR, taxa, 'o-', 'LineWidth', 2); % Gráfico semilogarítmico
title('SER vs SNR'); % Título do gráfico
xlabel('SNR (dB)'); % Rótulo do eixo x
ylabel('SER'); % Rótulo do eixo y
grid on; % Ativa a grade no gráfico
