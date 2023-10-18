%% **********AGRUPAMINETO DE BIOMARCADORES Y ESTADÍSTICA DE RESULTADOS********** %%
function [statistics, registro, registro2] = Statistics_pca_mod(groups, Metodo, registro)

%% INICIALIZACIÓN DE PARÁMETROS
% Diccionario de Agrupaciones
agrupacion = ["InitialYear_1", "InitialYear_plus_1", "InitialYear_2", "InitialYear_plus_2", ...
    "InitialYear_3", "InitialYear_plus_3", "InitialYear_4", "InitialYear_plus_4", ... 
    "InitialYear_5", "InitialYear_plus_5", "InitialYear_6", "InitialYear_plus_6"];
% Diccionario de Derivaciones
derivacion = ["I","II","III","aVL","aVR","aVF","V1","V2","V3","V4","V5","V6"];
% Diccionario de Biomarcadores
biomarcador = ["BPM","PQ","QT","QTc","MaxPeak","MinPeak","QRSampl_pp", ...
    "QRSd","QRS_Area","QRS_Energy","QRS_Power"];

if Metodo == "PCA"
        i = 1;
    else
        i = 12;
end

%% ESTADÍSTICAS LILLIETEST
for g = 1:length(agrupacion)    % Agrupaciones
    grupo = agrupacion(g);
    
    for d = 1:i                     % Derivaciones
        der = derivacion(d);
        
        for b = 1:length(biomarcador)   % Biomarcadores
            bio = biomarcador (b);
            
            % Selección de la prueba evaluada
            prueba = groups.(grupo).(der).(bio);

            % Cálculo del coef. h con la función de Lillietest
            [statistics.lillietest.(grupo).(der).(bio)] = lillietest(prueba);

        end
    end
end

%% ESTADÍSTICAS SIGNRANK
for d = 1:i                     % Derivaciones
    der = derivacion(d);

    for b = 1:length(biomarcador)   % Biomarcadores
        bio = biomarcador (b);

        for y = 1:2:length(agrupacion)

            % Selección de las pruebas evaluadas
            sub = (y+1)/2;
            ind = min([length(groups.(agrupacion(y)).(der).(bio)), ...
                length(groups.(agrupacion(y+1)).(der).(bio))]);
            PruebaInicial = groups.(agrupacion(y)).(der).(bio)(1:ind);
            prueba_post = groups.(agrupacion(y+1)).(der).(bio)(1:ind);

            % PruebaInicial_4 = groups.(agrupacion(3)).(der).(bio);
            % prueba_4 = groups.(agrupacion(4)).(der).(bio);

            % Cálculo de h con la función de Signrank
            [statistics.signrank.("Years_0_and_"+sub).(der).(bio)] = signrank(PruebaInicial,prueba_post);
            % [statistics.signrank.("Years_0_and_4").(der).(bio)] = signrank(PruebaInicial_4,prueba_4);
            
            registro.(bio)(((y+1)/2)+1, 1) = ("Years_0_and_"+sub);
            registro2.(bio)(((y+1)/2)+1, 1) = ("Years_0_and_"+sub);
            
            if d == 1
                    registro.(bio)(1, 1) = "YEAR";
                    registro2.(bio)(1, 1) = "YEAR";
            end

            if Metodo == "PCA"
                registro.(bio)(1, 14) = "PC1"; 
                registro.(bio)(((y+1)/2)+1, 14) = statistics.signrank.("Years_0_and_"+sub).(der).(bio);
                registro2.(bio)(1, 14) = "PC1"; 
                registro2.(bio)(((y+1)/2)+1, 14) = ind;
            else
                registro.(bio)(1, d+1) = strjoin(["Der " der], ''); 
                registro.(bio)(((y+1)/2)+1, d+1) = statistics.signrank.("Years_0_and_"+sub).(der).(bio);
                registro2.(bio)(1, d+1) = strjoin(["Der " der], ''); 
                registro2.(bio)(((y+1)/2)+1, d+1) = ind;
            end
            
        end
    end
end
end