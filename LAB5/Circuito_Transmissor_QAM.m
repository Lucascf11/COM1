close all; clear all; clc;
pkg load signal;
pkg load communications;


%---------------------------------------------------------------------------------------------------------------------
%                                       Codificação do Transmissor
%---------------------------------------------------------------------------------------------------------------------
M = 16;
info = randi([0, 1], 1, M); % Gerando informação binária aleatória de M bits
bits = log2(M); % Definindo bits por símbolo como log na base 2 de M
fc = 10; % Frequência da portadora

% Definindo parâmetros de representação de pulsos e de amostragens
periodos_pulso_NRZ = 400;
amostras_periodo = 20;
N = periodos_pulso_NRZ * amostras_periodo;
A = 1;

% Definindo taxa de bits e tempo de símbolos
Rb = M;
Rs = Rb/bits;

% Definindo frequência de amostragem e vetor tempo
fs = Rs * N;
ts = 1/fs;
t = [0:ts:1-ts];


% Passando pelo conversor decimal
info_DEC = bi2de(reshape(info, bits, [])', 'left-msb')';

% Realizando modulação QAM em M-QAM
sinalQAM = qammod(info_DEC,M).';

% Separando parte real (inphase) e imagíaria (quadratura)
sinalQAM_real = real(sinalQAM);
sinalQAM_imag = imag(sinalQAM);

% Fazendo os 4 PAMs
sinalQAM_real_up = upsample(sinalQAM_real,N);
sinalQAM_imag_up = upsample(sinalQAM_imag,N);
filtroRZ = ones(1,N);

% Realizando codificação NRZ da quadradtura e fase do QAM
sinalQAM_real_RZ = filter(filtroRZ,1,sinalQAM_real_up);
sinalQAM_imag_RZ = filter(filtroRZ,1,sinalQAM_imag_up);

% Fazendo os multiplicadores
cosseno = A*cos(2 * pi * fc * t);
seno = A*sin(2 * pi * fc * t);

% Realizando as multiplicações
sinalQAM_real_RZ_deslocado = cosseno .* sinalQAM_real_RZ;
sinalQAM_imag_RZ_deslocado = -seno .* sinalQAM_imag_RZ;

% Obtendo o sinal final
sinal_final_tx = sinalQAM_real_RZ_deslocado + sinalQAM_imag_RZ_deslocado;

%---------------------------------------------------------------------------------------------------------------------
%                                       Plots do Transmissor
%---------------------------------------------------------------------------------------------------------------------


figure(1)
% Plot do RZ do real
subplot(211)
plot(t, sinalQAM_real_RZ);
title('RZ Real');
xlabel('Tempo amostral'); ylabel('Amplitude');
ylim([-4 4]);
% Plot do RZ do imaginário
subplot(212)
plot(t, sinalQAM_imag_RZ);
title('RZ Imaginário');
xlabel('Tempo amostral'); ylabel('Amplitude');
ylim([-4 4]);

figure(2)
plot(t,sinal_final_tx);
title('sinal final');
xlabel('Tempo amostral'); ylabel('Amplitude');


%---------------------------------------------------------------------------------------------------------------------
%                                       Codificação o Receptor
%---------------------------------------------------------------------------------------------------------------------


sinal_inicial_rx = sinal_final_tx;

% 1. Multiplicação para banda base
sinal_rx_real = cosseno .* sinal_inicial_rx;
sinal_rx_imag = -seno .* sinal_inicial_rx;

% 2. Filtro casado
filtro_rx = fliplr(filtroRZ);
sinal_rx_real_filtrado_casado = filter(filtro_rx, 1, sinal_rx_real)/sum(filtroRZ);
sinal_rx_imag_filtrado_casado = filter(filtro_rx, 1, sinal_rx_imag)/sum(filtroRZ);

% 3. Filtro passa-baixa
filtro_passa_baixas = fir1(100, (fc*2) / fs);  % Ordem 100 para melhor resposta
sinal_rx_real_filtrado = filter(filtro_passa_baixas, 1, sinal_rx_real_filtrado_casado);
sinal_rx_imag_filtrado = filter(filtro_passa_baixas, 1, sinal_rx_imag_filtrado_casado);

% 4. Amostragem (Multiplica-se por 2 para compensar a perca de potência pela metade quando passa pelo filtro casado)
sinal_rx_real_amostrado = 2*sinal_rx_real_filtrado(N:N:end);
sinal_rx_imag_amostrado = 2*sinal_rx_imag_filtrado(N:N:end);

% Limiarizando o sinal

% Parte real
sinal_rx_real_amostrado(sinal_rx_real_amostrado <= -2) = -3;
sinal_rx_real_amostrado(sinal_rx_real_amostrado > -2 & sinal_rx_real_amostrado <= 0) = -1;
sinal_rx_real_amostrado(sinal_rx_real_amostrado > 0 & sinal_rx_real_amostrado <= 2) = 1;
sinal_rx_real_amostrado(sinal_rx_real_amostrado > 2) = 3;

% Parte imaginária
sinal_rx_imag_amostrado(sinal_rx_imag_amostrado <= -2) = -3;
sinal_rx_imag_amostrado(sinal_rx_imag_amostrado > -2 & sinal_rx_imag_amostrado <= 0) = -1;
sinal_rx_imag_amostrado(sinal_rx_imag_amostrado > 0 & sinal_rx_imag_amostrado <= 2) = 1;
sinal_rx_imag_amostrado(sinal_rx_imag_amostrado > 2) = 3;

% Reconstruindo o sinal QAM a partir das partes real e imaginária
sinal_rx_reconstituido = sinal_rx_real_amostrado + 1i * sinal_rx_imag_amostrado;

% Realizando demodulação QAM do sinal e retornando-o para o diagrama de constelação QAM
sinalQAM_demod = qamdemod(sinal_rx_reconstituido,M);

info_BIN = de2bi(reshape(sinalQAM_demod, bits, [])', 'left-msb')';
info_BIN = info_BIN(:)';  % Isso vai garantir que `info_BIN` seja um vetor linha


