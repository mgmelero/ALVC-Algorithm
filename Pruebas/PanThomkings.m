% Cargar la señal ECG (por ejemplo, "ecg_signal" es un vector con la señal ECG)
% Puedes cargar tu propia señal o utilizar una señal de ejemplo disponible en MATLAB

% Aplicar un filtro pasa-banda para enfocar la frecuencia de la señal ECG (opcional, pero recomendado)
fs = 1000; % Frecuencia de muestreo (ajusta según la frecuencia de tu señal ECG)
low_freq = 5; % Frecuencia de corte inferior (Hz)
high_freq = 15; % Frecuencia de corte superior (Hz)
[b, a] = butter(1, [low_freq, high_freq] / (fs / 2), 'bandpass');
filtered_ecg = filtfilt(b, a, ecg_signal);

% Normalizar la señal para que esté entre 0 y 1 (opcional, pero recomendado)
normalized_ecg = (filtered_ecg - min(filtered_ecg)) / (max(filtered_ecg) - min(filtered_ecg));

% Aplicar el algoritmo Pan-Tompkins para detectar las ondas P, QRS y T
[qrs_peaks, qrs_locs] = findpeaks(normalized_ecg, 'MinPeakHeight', 0.6, 'MinPeakDistance', 0.2 * fs);

% Visualizar la señal ECG y los picos detectados
t = (0:length(ecg_signal)-1) / fs;
figure;
plot(t, ecg_signal, 'b');
hold on;
plot(t, normalized_ecg, 'r');
scatter(qrs_locs / fs, qrs_peaks, 'g', 'filled');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');
legend('Señal ECG', 'Señal ECG Normalizada', 'Picos QRS');
title('Delineación de señal ECG con algoritmo Pan-Tompkins');
grid on;
