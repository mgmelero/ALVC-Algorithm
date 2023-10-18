%% **********BÚSQUEDA DE BIOMARCADORES Y ESTADÍSTICA DE RESULTADOS********** %%
function [Biomarkers, Registro] = Biomarkers(inputdir, paciente, fecha, ...
    process, method, pca)

%% INICIALIZACIÓN DE PARÁMETROS
etiquetas = [];
Biomarkers = {};
% Registro de resultados
Registro.reg1 = false;
Registro.reg2 = strings(1,12); 

%% CARGAR PARÁMETROS
[HEADER,senalpromediada,tags,position] = FilesLoad(process, inputdir, ...
    paciente, fecha, method, pca);
% Comprobación de los parámetros
Registro.reg1 = false;
if isempty (HEADER) || isempty (senalpromediada) || isempty (tags) || ...
        isempty (position)
    % Si faltan datos, finaliza la ejecución de esta función
    Registro.reg1 = true;
    return
end

%% BÚSQUEDA DE BIOMARCADORES
% Si la delineación es de PCA, sólo habrá que delinear la primera señal
if pca == 2
    i = 1;
else
    i = 12;
end

for d = 1:i    % Derivaciones
    
    % Selección de la derivada y los Tags correspondientes
    der=strrep(string(HEADER.desc(d,:)),' ','');
    der_tags=tags.(der);

    %% INICIALIZACIÓN DE LOS PARÁMETROS
    % Creación de la estructura que contiene a todos los biomarcadores
    Biomarkers.(der).BPM = [];
    Biomarkers.(der).PQ = [];
    Biomarkers.(der).QT = [];
    Biomarkers.(der).QTc = [];
    Biomarkers.(der).MaxPeak = [];
    Biomarkers.(der).MinPeak = [];
    Biomarkers.(der).QRSampl_pp = [];
    Biomarkers.(der).QRSd = [];
    Biomarkers.(der).QRS_interval = [];
    Biomarkers.(der).QRS_Area = [];
    Biomarkers.(der).QRS_Energy = [];
    Biomarkers.(der).QRS_Power = [];

    %% BIOMARCADORES
    % Ancho del Intervalo RR
    try
        RR=median(diff(tags.(der).qrs));
    catch
        try
            if method == "SLR"
                RR=median(diff(position.qrs));
            else
                RR=median(diff(position{d,1}.qrs));
            end
        end
    end
 
    %% Beats per Minute (BPM)
    % Units: 1(lat)/RR(ms)=1(lat)/(RR/1000(s))= ...
    % 1(lat)(60(s)/((RR/1000(s))*1(min)))=lat/min
    if exist ('RR','var')
        Biomarkers.(der).BPM = round(60/(RR/1000)); 
        etiquetas = strcat(etiquetas, 'BPM,');
    end

    % Condiciones para todos los biomarcadores
    if isfield (der_tags,'QRSon') && ~isempty(der_tags.QRSon) && ...
            ~isnan(der_tags.QRSon(1))
        
        % Condiciones para el biomarcador PQ
        if isfield (der_tags,'Pon') && ~isempty(der_tags.Pon) && ...
                ~isnan(der_tags.Pon(1)) 
    
    %% Intervalo PQ (Pon - QRSon)
            Biomarkers.(der).PQ = der_tags.QRSon(1) - der_tags.Pon(1);
            etiquetas = strcat(etiquetas, 'PQ,');
        end

        % Condiciones para los biomarcadores QT y QTc
        if isfield (der_tags,'Toff') && ~isempty(der_tags.Toff) && ...
                ~isnan(der_tags.Toff(1))

    %% Intervalo QT (QRSon - Toff)
            Biomarkers.(der).QT = der_tags.Toff(1) - der_tags.QRSon(1);
            etiquetas = strcat(etiquetas, 'QT,');

    %% Intervalo QTc (Fórmula de Bazett)
            if exist ('RR', 'var')
                Biomarkers.(der).QTc = (((Biomarkers.(der).QT)) / sqrt(RR));
                etiquetas = strcat(etiquetas, 'QTc,');
            end
        end

        % Condiciones para el resto de biomarcadores
        if isfield (der_tags,'QRSoff') && ~isempty(der_tags.QRSoff) && ...
                ~isnan(der_tags.QRSoff(1))

    %% Amplitud Peak to Peak del intervalo QRS
            if pca == 1
                % Obtener offset de la línea Isoeléctrica
                offset = median(senalpromediada.(der)((der_tags.QRSon(1)-30) ...
                    : (der_tags.QRSon(1))));
    
                % Intervalo QRS eliminando el offset
                QRS_interval_offset = senalpromediada.(der)(der_tags.QRSon(1) ...
                    : der_tags.QRSoff(1)) - offset;
            elseif pca == 2
                % Obtener offset de la línea Isoeléctrica
                offset = median(senalpromediada(1, (der_tags.QRSon(1)-30) ...
                    : (der_tags.QRSon(1))));
    
                % Intervalo QRS eliminando el offset
                QRS_interval_offset = senalpromediada(1, der_tags.QRSon(1) ...
                    : der_tags.QRSoff(1)) - offset;
            end
    
            % Pico Máximo y Pico Mínimo
            Biomarkers.(der).MaxPeak = max(QRS_interval_offset);
            Biomarkers.(der).MinPeak = min(QRS_interval_offset);
    
            % Amplitud Peak to Peak (nV)
            Biomarkers.(der).QRSampl_pp = ...
                Biomarkers.(der).MaxPeak - Biomarkers.(der).MinPeak;
            etiquetas = strcat(etiquetas, 'QRSampl_pp,');

    %% Ancho del intervalo QRS
            Biomarkers.(der).QRSd = der_tags.QRSoff(1) - der_tags.QRSon(1);
            etiquetas = strcat(etiquetas, 'QRSd,');
            
            if pca == 1
                % Intervalo QRS
                Biomarkers.(der).QRS_interval = ...
                    senalpromediada.(der)(der_tags.QRSon(1):der_tags.QRSoff(1));
            elseif pca == 2
                % Intervalo QRS
                Biomarkers.(der).QRS_interval = ...
                    senalpromediada(1, der_tags.QRSon(1):der_tags.QRSoff(1));
            end
    
    %% Área del intervalo QRS
            Biomarkers.(der).QRS_Area = (1/(HEADER.freq))...
                *sum(abs(Biomarkers.(der).QRS_interval));
            etiquetas = strcat(etiquetas, 'QRS_Area,');
    
    %% Energía del intervalo QRS
            Biomarkers.(der).QRS_Energy = (1/(HEADER.freq))...
                *sum((Biomarkers.(der).QRS_interval).^2);
            etiquetas = strcat(etiquetas, 'QRS_Energy,');
    
    %% Potencia del intervalo QRS
            Biomarkers.(der).QRS_Power = (1/(Biomarkers.(der).QRSd))...
                *sum((Biomarkers.(der).QRS_interval).^2);
            etiquetas = strcat(etiquetas, 'QRS_Power,');

        end
    end

    % Registro de etiquetas
        if ~isempty (etiquetas)            
            Registro.reg2(d) = etiquetas(1:end-1);
        else
            Registro.reg2(d) = "NO_BIOMARKERS";
        end

    clear der der_tags RR offset QRS_interval_offset etiquetas
    etiquetas = [];
end
end