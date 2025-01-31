clc; close all; clear all;

pkg load signal;
pkg load communications;

% Lendo o arquivo de áudio
[x1, fs1] = audioread('audio_quantizacao2.wav');
x1 = x1';

% Pré-processamento do sinal
y1 = x1 + abs(min(x1)); % Transladando para evitar valores negativos
bits = 8; % Número de bits de quantização
niveis = 2^bits; % Níveis de quantização
nivel_maximo = niveis - 1;
delta = (max(y1) - min(y1)) / niveis; % Tamanho do passo de quantização

N = 10; % Número de amostras da superamostragem
A = 5; % Amplitude do NRZ
var = 3; %Variância do ruído branco

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
sinal_quantizado_binario_RZ = sinal_quantizado_binario_formatado * A;

sinal_quantizado_binario_NRZ_up = upsample(sinal_quantizado_binario_NRZ,N);
sinal_quantizado_binario_RZ_up = upsample(sinal_quantizado_binario_RZ,N);

filtro_de_superamostragem = ones(1,N);

% Transformando o sinal em NRZ
sinal_quantizado_NRZ_filtrado = filter(filtro_de_superamostragem, 1, sinal_quantizado_binario_NRZ_up);

% Transformando o sinal em RZ
sinal_quantizado_RZ_filtrado = filter(filtro_de_superamostragem, 1, sinal_quantizado_binario_RZ_up);

% Gerando o ruído AWGN
ruido = sqrt(var)*randn(1,length(sinal_quantizado_binario_NRZ_up));

% Adicionando ruído ao NRZ
sinal_NRZ_com_ruido = sinal_quantizado_NRZ_filtrado + ruido;

% Adicionando ruído ao RZ
sinal_RZ_com_ruido = sinal_quantizado_RZ_filtrado + ruido;

% Criando filtro casado da recepção
filtro_rx = fliplr(filtro_de_superamostragem);

% Filtrando o sinal NRZ antes da recepção
sinal_NRZ_com_ruido_filtrado = filter(filtro_rx, 1, sinal_NRZ_com_ruido);
sinal_NRZ_com_ruido_filtrado_normalizado = sinal_NRZ_com_ruido_filtrado/sum(filtro_de_superamostragem);

% Filtrando o sinal NRZ antes da recepção
sinal_RZ_com_ruido_filtrado = filter(filtro_rx, 1, sinal_RZ_com_ruido);
sinal_RZ_com_ruido_filtrado_normalizado = sinal_RZ_com_ruido_filtrado/sum(filtro_de_superamostragem);

% Amostrando sinal NRZ ruidoso sem filtrar
amostras_sinal_final_NRZ_sem_filtrar  = sinal_NRZ_com_ruido(N:N:end);

% Amostrando sinal RZ ruidoso sem filtrar
amostras_sinal_final_RZ_sem_filtrar = sinal_RZ_com_ruido(N:N:end);

% Amostrando sinal NRZ ruidoso após filtrar
amostras_sinal_final_NRZ_filtrado  = sinal_NRZ_com_ruido_filtrado_normalizado(N:N:end);

% Amostrando sinal RZ ruidoso após filtrar
amostras_sinal_final_RZ_filtrado = sinal_RZ_com_ruido_filtrado_normalizado(N:N:end);


% Recuperando os bits do NRZ sem filtrar
bits_recuperados_NRZ_sem_filtrar = amostras_sinal_final_NRZ_sem_filtrar > 0;
bit_error_ratio_NRZ_sem_filtrar = sum(xor(sinal_quantizado_binario_formatado,bits_recuperados_NRZ_sem_filtrar))

% Recuperando os bits do RZ sem filtrar
bits_recuperados_RZ_sem_filtrar = amostras_sinal_final_RZ_sem_filtrar > A/2;
bit_error_ratio_RZ_sem_filtrar = sum(xor(sinal_quantizado_binario_formatado,bits_recuperados_RZ_sem_filtrar))


% Recuperando os bits do NRZ após filtrar
bits_recuperados_NRZ_filtrado = amostras_sinal_final_NRZ_filtrado > 0;
bit_error_ratio_NRZ_filtrado = sum(xor(sinal_quantizado_binario_formatado,bits_recuperados_NRZ_filtrado))

% Recuperando os bits do RZ após filtrar
bits_recuperados_RZ_filtrado = amostras_sinal_final_RZ_filtrado > A/2;
bit_error_ratio_RZ_filtrado = sum(xor(sinal_quantizado_binario_formatado,bits_recuperados_RZ_filtrado))


% Reconversão dos bits NRZ  para valores decimais
sinal_NRZ_binario_para_decimal = bi2de(reshape(bits_recuperados_NRZ_filtrado, [], bits), 'left-msb');

% Reconstrução do sinal desquantizado no NRZ
sinal_desquantizado_NRZ = sinal_NRZ_binario_para_decimal * delta;

% Normalização do sinal desquantizado para reprodução
sinal_desquantizado_NRZ = sinal_desquantizado_NRZ - abs(min(x1)); % Remove o DC offset


% Reconversão dos bits RZ  para valores decimais
sinal_RZ_binario_para_decimal = bi2de(reshape(bits_recuperados_RZ_filtrado, [], bits), 'left-msb');

% Reconstrução do sinal desquantizado no RZ
sinal_desquantizado_RZ = sinal_RZ_binario_para_decimal * delta;

% Normalização do sinal desquantizado para reprodução
sinal_desquantizado_RZ = sinal_desquantizado_RZ - abs(min(x1)); % Remove o DC offset

%-------------------------------------------------------------------------
%PLOTAGENS
%-------------------------------------------------------------------------
figure(1)
subplot(2,1,1); grid on; hold on;
plot(sinal_quantizado_NRZ_filtrado);
xlim([15000*N 16000*N])
# ylim([-12 12])
title('Sinal NRZ');
xlabel('Amostragem');
ylabel('Amplitude');

subplot(2,1,2); grid on; hold on;
plot(sinal_quantizado_RZ_filtrado);
xlim([15000*N 16000*N])
title('Sinal RZ');
xlabel('Amostragem');
ylabel('Amplitude');

figure(2)
subplot(2,1,1); grid on; hold on;
plot(sinal_NRZ_com_ruido);
xlim([15000*N 16000*N])
# ylim([-12 12])
title('Sinal NRZ Ruidoso sem filtrar');
xlabel('Amostragem');
ylabel('Amplitude');

subplot(2,1,2); grid on; hold on;
plot(sinal_RZ_com_ruido);
xlim([15000*N 16000*N])
title('Sinal RZ Ruidoso sem filtrar');
xlabel('Amostragem');
ylabel('Amplitude');

figure(3)
subplot(2,1,1); grid on; hold on;
plot(sinal_NRZ_com_ruido_filtrado_normalizado);
xlim([15000*N 16000*N])
# ylim([-12 12])
title('Sinal NRZ Ruidoso após filtrar');
xlabel('Amostragem');
ylabel('Amplitude');

subplot(2,1,2); grid on; hold on;
plot(sinal_RZ_com_ruido_filtrado_normalizado);
xlim([15000*N 16000*N])
title('Sinal RZ Ruidoso após filtrar');
xlabel('Amostragem');
ylabel('Amplitude');

figure(4);

subplot(2, 1, 1);
plot(t1, x1);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');


subplot(2, 1, 2);
stem(t1, sinal_quantizado, 'r');
title('Sinal Quantizado');
xlabel('Tempo (s)');
ylabel('Amplitude Quantizada');

figure(5);

subplot(2, 1, 1);
plot(t1, x1);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t1, sinal_desquantizado_NRZ, 'g');
title('Sinal Desquantizado (Reconstruído) no NRZ');
xlabel('Tempo (s)');
ylabel('Amplitude Normalizada');

figure(6);

subplot(2, 1, 1);
plot(t1, x1);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t1, sinal_desquantizado_RZ, 'g');
title('Sinal Desquantizado (Reconstruído) no RZ');
xlabel('Tempo (s)');
ylabel('Amplitude Normalizada');