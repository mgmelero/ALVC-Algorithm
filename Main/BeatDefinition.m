%% **********BÚSQUEDA DE BIOMARCADORES Y ESTADÍSTICA DE RESULTADOS********** %%
function [beats] = BeatDefinition(beats,sinal,tags,method,limite)

%% FILTRADO DE FALSOS LATIDOS (El filtrado se hace en la etapa anterior)
% Se eliminan picos muy cercanos
% fake_R = find (diff(tags.qrs) < 750); % (PQ + QT) fisiológicos + 100ms
% for r = length(fake_R):-1:1
%     beats(fake_R(r),:) = [];
%     tags.qrs(fake_R(r)) = [];
% end


%% INICIALIZACIÓN DE VARIABLES
time = zeros(length(beats(:,1)),length(beats(:,1)));
ceros = zeros(1,length(beats(:,1)));
% Se niegan que aparezcan los warnings
warning('off','all')

%% IDENTIFICACIÓN DE DESFASE ENTRE LATIDOS
% Se definen los dos latidos que serán comparados
for b1 = 1:length(beats(:,1))     % Latido referencia
    for b2 = 1:length(beats(:,1)) % Latido secundario
        if b1 == b2     % No pueden compararse los mismos latidos
            continue
        else
        % Se resetean los warnings
            lastwarn('', '');
        % Se obtiene el desfase entre latidos
            time(b1,b2) = finddelay (beats(b1,:), beats(b2,:));
        % Se evalúan si existe algún warning
            [~, warnId] = lastwarn();
        % Si no existe correlación entre señales, se cambia el valor a 999
            if ~isempty (warnId)
                time(b1,b2) = 0.5;
            end
        end
    end
    % Cálculo de zeros por cada fila
    ceros(1,b1) = length (find(~time(b1,:)));
end


%% BÚSQUEDA DEL LATIDO DE REFERENCIA
% Búsqueda del latido que mayor número de ceros contenga en la matriz de
% desfase, es decir, el primer latido de la mayoría de los latidos que
% están alineados.
Beat_ref = find(ceros == max(ceros),1);
qrs_length = max (tags.qrsoff - tags.qrson);

% Y se obtiene el desfase de referencia para todos los latidos
X_corr = time (Beat_ref,:);


%% ALINEACIÓN DE LATIDOS
% Si están todos los latidos alineados
if sum (abs(X_corr)) == 0
    return   % Sale de la función
end

% Alineación por latidos
% for b = length(tags.qrs)-1:-1:1
for b = length(tags.qrs):-1:1
    try     % Se pretende sacar cada uno de los latidos en la ventana establecida
        if b ~= Beat_ref && X_corr(b) > qrs_length * 1.2 % Si el latido está muy desfasado, es porque no se ha extraído bien.
            beats(b,:) = [];
        elseif b ~= Beat_ref && X_corr(b) ~= 0 && method == "SLR"
            beats(b,:) = sinal(tags.qrs - limite.N1 + X_corr(b) ...
                : tags.qrs + limite.N2 -1 + X_corr(b));
        elseif b ~= Beat_ref && X_corr(b) ~= 0 && method == "SL"
            beats(b,:) = sinal(tags.qrs(b) - limite.N1 + X_corr(b) ...
                : tags.qrs(b) + limite.N2 - 1 + X_corr(b));
        elseif ~all(tags.qrs)
            beats(b,:) = [];
        end
    catch   % Si faltasen datos, el latido queda descartado
        beats(b,:) = [];
        continue
    end
end
end