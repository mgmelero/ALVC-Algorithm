% Paso 1: Cargar la señal ECG o utilizar una señal de ejemplo
% Suponiendo que ya tienes una señal ECG cargada en el vector "ecg_signal"
% Si no tienes una señal, puedes utilizar la señal de ejemplo incluida en MATLAB:
% load ecgdata.mat; % Cargará la señal de ejemplo como "ecgdata"

% Paso 2: Aplicar el algoritmo WaveDet para detectar los picos QRS
fs = 1000; % Frecuencia de muestreo (ajusta según la frecuencia de tu señal ECG)

% Llamada a la función wavedet para detectar los picos QRS
qrs_locs = wavedet(ecg_signal, fs);

% Paso 3: Visualizar la señal ECG y los picos QRS detectados
t = (0:length(ecg_signal) - 1) / fs;
figure;
plot(t, ecg_signal, 'b');
hold on;
scatter(qrs_locs / fs, ecg_signal(qrs_locs), 'r', 'filled');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');
legend('Señal ECG', 'Picos QRS detectados');
title('Delineación de señal ECG con algoritmo WaveDet');
grid on;