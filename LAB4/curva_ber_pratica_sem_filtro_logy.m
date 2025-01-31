clear all
close all
clc

var_indice = [5:5:200];
N = 20;
LIMIT_SNR = 20;
filtro_tx = ones(1, N);
filtro_rx = fliplr(filtro_tx);
A = 5;
limiarNRZ = 0;
limiarRZ = A/2;
Rb = 1000000;
Tb = 1 / Rb;
passo_t = Tb / N;
t = [0:passo_t:1-passo_t];

% Gerar sequência binária aleatória
info = randi([0, 1], 1, Rb); 
info_up = upsample(info, N);
sinal_tx_NRZ = filter(filtro_tx, 1, info_up) * 2 * A - A;
sinal_tx_RZ = filter(filtro_tx, 1, info_up) * A;

dB = 10 * log10(N);

% Função personalizada para calcular erros de bit
function [numErrors, ber] = biterr_custom(x, y)
    if length(x) ~= length(y)
        error("Os vetores devem ter o mesmo comprimento.");
    end
    numErrors = sum(xor(x,y));
    ber = numErrors / length(x);
end

for SNR = 0:LIMIT_SNR
    SNR
    sinal_rx_NRZ = awgn(sinal_tx_NRZ, SNR - (dB), 'measured');
    sinal_rx_RZ = awgn(sinal_tx_RZ, SNR - (dB), 'measured');
    Z_T = sinal_rx_NRZ(N:N:end);
    info_hat_NRZ = Z_T > limiarNRZ;
    Z1_T = sinal_rx_RZ(N:N:end);
    info_hat_RZ = Z1_T > limiarRZ;
    [num_erro(SNR+1), BER_NRZ(SNR+1)] = biterr_custom(info, info_hat_NRZ);
    [num_erro1(SNR+1), BER_RZ(SNR+1)] = biterr_custom(info, info_hat_RZ);
end

% Plotagem
figure(1)
subplot(211)
plot(t, sinal_tx_NRZ)
xlim([0 10 * Tb])
ylim([-(2*A) 2*A])
title('Sinal Transmitido')

subplot(212)
plot(t, sinal_rx_NRZ)
xlim([0 10 * Tb])
ylim([-(2*A) 2*A])
title('Sinal Recebido')


figure(2)
subplot(211)
plot(t, sinal_tx_RZ)
xlim([0 10 * Tb])
ylim([-(2*A) 2*A])
title('Sinal Transmitido')

subplot(212)
plot(t, sinal_rx_RZ)
xlim([0 10 * Tb])
ylim([-(2*A) 2*A])
title('Sinal Recebido')

figure(3); hold on;
semilogy([0:LIMIT_SNR], BER_RZ)
semilogy([0:LIMIT_SNR], BER_NRZ)
title('BER vs SNR')
xlabel('SNR (dB)')
ylabel('BER')
grid on
legend('Curva BER RZ','Curva BER NRZ')
