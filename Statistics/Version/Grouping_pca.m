%% **********AGRUPAMINETO DE BIOMARCADORES********** %%
function [Agrupamientos, Registro] = Grouping_pca(Paciente_Bio, Agrupamientos, Registro)
            
%% INICIALIZACIÓN DE PARÁMETROS
% Diccionario de Derivaciones
Derivacion = ["I"];
% Diccionario de Biomarcadores
Biomarcador = ["BPM","PQ","QT","QTc","MaxPeak","MinPeak","QRSampl_pp", ...
    "QRSd","QRS_Area","QRS_Energy","QRS_Power"];


if isfield(Paciente_Bio,"InitialYear") && ...
        (isfield(Paciente_Bio,"InitialYear_plus_2") || isfield(Paciente_Bio,"InitialYear_plus_4"))

    for d = 1:1                         % Derivaciones
        
        % Selección de la derivación
        der = Derivacion(d);
        
        for b = 1:length(Biomarcador)    % Biomarcadores

            % Selección del biomarcador
            bio = Biomarcador(b);

            % Existe el biomarcador en el año inicial y pasados 2 años
            if isfield(Paciente_Bio,"InitialYear_plus_2") && ...
                    ~isempty (Paciente_Bio.InitialYear.(der).(bio)) && ...
                    ~isempty (Paciente_Bio.InitialYear_plus_2.(der).(bio))
                try
                    % Se agrupan todos los biomarcadores de los pacientes
                    Agrupamientos.InitialYear_2.(der).(bio)(end+1) = Paciente_Bio.InitialYear.(der).(bio);
                    Agrupamientos.Year_plus_2.(der).(bio)(end+1) = Paciente_Bio.InitialYear_plus_2.(der).(bio);

                catch
                    % Se agrupan todos los biomarcadores de los pacientes
                    Agrupamientos.InitialYear_2.(der).(bio)(1) = Paciente_Bio.InitialYear.(der).(bio);
                    Agrupamientos.Year_plus_2.(der).(bio)(1) = Paciente_Bio.InitialYear_plus_2.(der).(bio);
                end

                % Registro de etiquetas
                try
                    Registro.reg2{d} = strcat(Registro.reg2{d}, ',' + bio);
                catch
                    Registro.reg2{d} = bio;
                end
            end

            % Existe el biomarcador en el año inicial y pasados 4 años
            if isfield(Paciente_Bio,"InitialYear_plus_4") && ...
                    ~isempty (Paciente_Bio.InitialYear.(der).(bio)) && ...
                    ~isempty (Paciente_Bio.InitialYear_plus_4.(der).(bio))
                try
                    % Se agrupan todos los biomarcadores de los pacientes
                    Agrupamientos.InitialYear_4.(der).(bio)(end+1) = Paciente_Bio.InitialYear.(der).(bio);
                    Agrupamientos.Year_plus_4.(der).(bio)(end+1) = Paciente_Bio.InitialYear_plus_4.(der).(bio);

                catch
                    % Se agrupan todos los biomarcadores de los pacientes
                    Agrupamientos.InitialYear_4.(der).(bio)(1) = Paciente_Bio.InitialYear.(der).(bio);
                    Agrupamientos.Year_plus_4.(der).(bio)(1) = Paciente_Bio.InitialYear_plus_4.(der).(bio);
                end

                % Registro de etiquetas
                try
                    Registro.reg4{d} = strcat(Registro.reg4{d}, ',' + bio);
                catch
                    Registro.reg4{d} = bio;
                end
            end
        end
    end
end
end
