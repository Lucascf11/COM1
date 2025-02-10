close all; clear all; clc;
pkg load signal;
pkg load communications;

M = 64;
SNR = 10;
Simbolos = 1000;
info = randint(1,Simbolos,M); % Gerando informação binária aleatória de M bits


sinal_QAM = qammod(info,M);

sinal_ruidoso = awgn(sinal_QAM,SNR);


sinal_QAM_demod = qamdemod(sinal_ruidoso,M);

% Plots
scatterplot(sinal_QAM);

scatterplot(sinal_ruidoso);