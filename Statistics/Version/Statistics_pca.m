%% **********AGRUPAMINETO DE BIOMARCADORES Y ESTADÍSTICA DE RESULTADOS********** %%
function [statistics] = Statistics_pca(groups)

%% INICIALIZACIÓN DE PARÁMETROS
% Diccionario de Agrupaciones
agrupacion = ["InitialYear_2","Year_plus_2","InitialYear_4","Year_plus_4"];
% Diccionario de Derivaciones
derivacion = ["I"];
% Diccionario de Biomarcadores
biomarcador = ["BPM","PQ","QT","QTc","MaxPeak","MinPeak","QRSampl_pp", ...
    "QRSd","QRS_Area","QRS_Energy","QRS_Power"];


%% ESTADÍSTICAS LILLIETEST
for g = 1:length(agrupacion)    % Agrupaciones
    grupo = agrupacion(g);
    
    for d = 1:1                     % Derivaciones
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
for d = 1:1                     % Derivaciones
    der = derivacion(d);

    for b = 1:length(biomarcador)   % Biomarcadores
        bio = biomarcador (b);

        % Selección de las pruebas evaluadas
        ind = min([length(groups.(agrupacion(1)).(der).(bio)), ...
            length(groups.(agrupacion(2)).(der).(bio))]);
        PruebaInicial_2 = groups.(agrupacion(1)).(der).(bio)(1:ind);
        prueba_2 = groups.(agrupacion(2)).(der).(bio)(1:ind);
        
        PruebaInicial_4 = groups.(agrupacion(3)).(der).(bio);
        prueba_4 = groups.(agrupacion(4)).(der).(bio);

        % Cálculo de h con la función de Lillietest
        [statistics.signrank.("Years_0_and_2").(der).(bio)] = signrank(PruebaInicial_2,prueba_2);
        [statistics.signrank.("Years_0_and_4").(der).(bio)] = signrank(PruebaInicial_4,prueba_4);

    end
end
end