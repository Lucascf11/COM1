clear all; close all; clc;
pkg load signal;

N = 100;
A = 5;
var = 1;

info = [0 1 1 1 0 1]
info_NRZ = info * 2*A - A;
info_NRZ_up = upsample(info_NRZ,N);
filtroNRZ = ones(1,N);
sinalNRZ = filter(filtroNRZ, 1, info_NRZ_up);

ruido = sqrt(var)*randn(1,length(sinalNRZ));
r_t = sinalNRZ + ruido;

Z_t  = r_t(N/2:N:end);

info_hat = Z_t > 0
num_erro = sum(xor(info,info_hat))

subplot(3,1,1); grid on; hold on;
stem(sinalNRZ);

subplot(3,1,2); grid on; hold on;
plot(sinalNRZ);

subplot(3,1,3); grid on; hold on;
plot(r_t);

