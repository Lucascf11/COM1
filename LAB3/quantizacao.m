clc; close all; clear all;
pkg load signal;
pkg load communications;

% Lendo o arquivo de áudio
[x1, fs1] = audioread('audio_quantizacao2.wav');
x1 = x1';

% Pré-processamento do sinal
y1 = x1 + abs(min(x1)); % Transladando para evitar valores negativos
bits = 3; % Número de bits de quantização
niveis = 2^bits; % Níveis de quantização
nivel_maximo = niveis - 1; % Valor do último nível de quantização
delta = (max(y1) - min(y1)) / niveis; % Tamanho do passo de quantização

% Inicialização do vetor de quantização
vetor_quantizado = zeros(1, length(y1));

% Quantização Vetorial
z = y1 / delta;                               % Normalização do vetor
vetor_quantizado = round(z);                  % Quantização com arredondamento
vetor_quantizado(vetor_quantizado > nivel_maximo) = nivel_maximo;  % Clipping


% Conversão para representação binária
vetor_quantizado_binario = de2bi(vetor_quantizado, bits, 2, 'left-msb');

% Reorganizando os bits para uma única linha
vetor_binario_linha = reshape(vetor_quantizado_binario, 1, []);

% Reconversão dos bits para valores decimais
vetor_reconvertido_decimal = bi2de(reshape(vetor_quantizado_binario, [], bits), 'left-msb');

% Reconstrução do sinal desquantizado
vetor_desquantizado = vetor_reconvertido_decimal * delta;

% Normalização do sinal desquantizado para reprodução
vetor_desquantizado = vetor_desquantizado - 1; % Remove o DC offset
vetor_desquantizado = vetor_desquantizado / max(abs(vetor_desquantizado)); % Normaliza para [-1, 1]

% Reproduzindo o áudio
# sound(vetor_desquantizado, fs1);

% Salvando o áudio reconstruído
audiowrite('audio_reconstruido.wav', vetor_desquantizado, fs1);
disp('Áudio reconstruído salvo como "audio_reconstruido.wav".');

% Comparando os métodos de reconstrução (se houver outro processo)
% Para efeitos de teste, este é o mesmo vetor
erro = vetor_desquantizado - vetor_desquantizado;
disp(['Erro máximo entre os métodos: ', num2str(max(abs(erro)))]);

% Plot para visualização
t1 = (0:length(x1)-1) / fs1; % Tempo
figure;
subplot(3, 1, 1);
ploe('Sinal Original');
xlabet(t1, x1);
titll('Tempo (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
stem(t1, vetor_quantizado, 'r');
title('Sinal Quantizado');
xlabel('Tempo (s)');
ylabel('Amplitude Quantizada');

subplot(3, 1, 3);
plot(t1, vetor_desquantizado, 'g');
title('Sinal Desquantizado (Reconstruído)');
xlabel('Tempo (s)');
ylabel('Amplitude Normalizada');
