close all; clear all; clc;

Eb_No_dB = 0:15;
Eb_No = 10.^(Eb_No_dB/10);
BER_uni = qfunc(sqrt(Eb_No));
BER_bip = qfunc(sqrt(2*Eb_No));

figure(1); hold on; grid on
semilogy(Eb_No_dB,BER_uni);
semilogy(Eb_No_dB,BER_bip);
xlabel('E_b/N_0 (dB)')
ylabel('BER(P_B)')
title('CURVA TEÓRICA DE BER')
xlim([0 15])
ylim([1e-7 1])
legend('Curva BER RZ','Curva BER NRZ')

