clc; close all; clear all;
pkg load signal;
pkg load communications;

% Lendo o arquivo de áudio
[x1, fs1] = audioread('audio_quantizacao2.wav');
x1 = x1';

% Pré-processamento do sinal
y1 = x1 + abs(min(x1)); % Transladando para evitar valores negativos
bits = 13; % Número de bits de quantização
niveis = 2^bits; % Níveis de quantização
nivel_maximo = niveis - 1;
delta = (max(y1) - min(y1)) / niveis; % Tamanho do passo de quantização

N = 10; % Número de amostras da superamostragem
A = 10; % Amplitude do NRZ
var = 2; %Variância do ruído branco

t1 = (0:length(x1)-1) / fs1; % Vetor do tempo
T = 1/fs1; %Período de amostragem do sinal;


% Inicialização do vetor de quantização
sinal_quantizado = zeros(1, length(y1));

z = y1 / delta;                             % Normalização
sinal_quantizado = round(z);                % Quantização
sinal_quantizado(sinal_quantizado > nivel_maximo) = nivel_maximo;  % Clipping

% Conversão para representação binária
sinal_quantizado_binario = de2bi(sinal_quantizado, bits, 2, 'left-msb');

% Reorganizando os bits para uma única linha
sinal_quantizado_binario_formatado = reshape(sinal_quantizado_binario, 1, []);

% Transformando os bits em um sinal NRZ de amplitude pico a pico indo de A até -A
sinal_quantizado_binario_NRZ = sinal_quantizado_binario_formatado * 2*A - A;
sinal_quantizado_binario_NRZ_up = upsample(sinal_quantizado_binario_NRZ,N);

filtroNRZ = ones(1,N);

% Transformando o sinal em NRZ
sinal_quantizado_NRZ_filtrado = filter(filtroNRZ, 1, sinal_quantizado_binario_NRZ_up);

ruido = sqrt(var)*randn(1,length(sinal_quantizado_binario_NRZ_up));

%Adicionando ruído ao NRZ
sinal_com_ruido = sinal_quantizado_NRZ_filtrado + ruido;

% Amostrando sinal NRZ ruidoso
amostras_sinal_final  = sinal_com_ruido(N/2:N:end);

% Recuperando os bits do NRZ
bits_recuperados = amostras_sinal_final > 0;

bit_error_ratio = sum(xor(sinal_quantizado_binario_formatado,bits_recuperados))

% Reconversão dos bits para valores decimais
sinal_binario_para_decimal = bi2de(reshape(bits_recuperados, [], bits), 'left-msb');

% Reconstrução do sinal desquantizado
sinal_desquantizado = sinal_binario_para_decimal * delta;

% Normalização do sinal desquantizado para reprodução
sinal_desquantizado = sinal_desquantizado - abs(min(x1)); % Remove o DC offset

% Reproduzindo o áudio
# sound(sinal_desquantizado, fs1);

% Salvando o áudio reconstruído
audiowrite('audio_reconstruido.wav', sinal_desquantizado, fs1);
disp('Áudio reconstruído salvo como "audio_reconstruido.wav".');

%-------------------------------------------------------------------------
%PLOTAGENS
%-------------------------------------------------------------------------
figure(1);

subplot(3, 1, 1);
plot(t1, x1);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');


subplot(3, 1, 2);
stem(t1, sinal_quantizado, 'r');
title('Sinal Quantizado');
xlabel('Tempo (s)');
ylabel('Amplitude Quantizada');



subplot(3, 1, 3);
plot(t1, sinal_desquantizado, 'g');
title('Sinal Desquantizado (Reconstruído)');
xlabel('Tempo (s)');
ylabel('Amplitude Normalizada');



figure(2)

#  subplot(3,1,1); grid on; hold on;
#  stem(sinal_quantizado_NRZ_filtrado);

# # title('Sinal Desquantizado (Reconstruído)');
# # xlabel('Tempo (s)');
# # ylabel('Amplitude Normalizada')

subplot(2,1,1); grid on; hold on;
plot(sinal_quantizado_NRZ_filtrado);
xlim([15000*N 16000*N])
ylim([-12 12])
title('Sinal NRZ');
xlabel('Amostragem');
ylabel('Amplitude');

subplot(2,1,2); grid on; hold on;
plot(sinal_com_ruido);
xlim([15000*N 16000*N])

title('Sinal NRZ ruidoso');
xlabel('Amostragem');
ylabel('Amplitude');





