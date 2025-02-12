clear all
close all
clc

function [sinal_normalizado] = modnorm(sinal_QAM)
    % Calcula a energia média dos símbolos da constelação
    energia_media = mean(abs(sinal_QAM).^2);
    
    % Calcula o fator de normalização para energia unitária
    fator_normalizacao = 1 / sqrt(energia_media);
    
    % Normaliza o sinal QAM
    sinal_normalizado = sinal_QAM * fator_normalizacao;
  end  

LIMIT_SNR = 10;

M = 16;
Simbolos = 100000
info = randint(1,Simbolos,M); % Gerando informação binária aleatória de M bits
sinal_QAM = qammod(info,M);
sinal_QAM_normalizado = modnorm(sinal_QAM);


% Função personalizada para calcular erros de bit
for SNR = 0:LIMIT_SNR
    SNR
    sinal_QAM_ruido = awgn(sinal_QAM_normalizado, SNR,'measured');
    info_demod = qamdemod(sinal_QAM_ruido,M);
    [numErrors(SNR+1),taxa(SNR+1)] = symerr(info,info_demod);
end

figure(1); hold on;
semilogy([0:LIMIT_SNR], taxa)
title('SER vs SNR');
xlabel('SNR (dB)');
ylabel('SER');
grid on


# Fazer a normalizaçãodo QAM
# modnorm