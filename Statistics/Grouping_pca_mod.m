%% **********AGRUPAMINETO DE BIOMARCADORES********** %%
function [Agrupamientos, Registro] = Grouping_pca_mod(Paciente_Bio, Agrupamientos, Registro, Metodo)
            
%% INICIALIZACIÓN DE PARÁMETROS
% Diccionario de Derivaciones
Derivacion = ["I","II","III","aVL","aVR","aVF","V1","V2","V3","V4","V5","V6"];
% Diccionario de Biomarcadores
Biomarcador = ["BPM","PQ","QT","QTc","MaxPeak","MinPeak","QRSampl_pp", ...
    "QRSd","QRS_Area","QRS_Energy","QRS_Power"];
% Diccionario de Agrupaciones
Dictionary = ["InitialYear_plus_1", "InitialYear_plus_2", "InitialYear_plus_3", ...
    "InitialYear_plus_4", "InitialYear_plus_5", "InitialYear_plus_6"];


if isfield(Paciente_Bio,"InitialYear") && ...
        (isfield(Paciente_Bio, Dictionary(1)) || isfield(Paciente_Bio, Dictionary(2)) || ...
        isfield(Paciente_Bio, Dictionary(3)) || isfield(Paciente_Bio, Dictionary(4)) || ...
        isfield(Paciente_Bio, Dictionary(5)) || isfield(Paciente_Bio, Dictionary(6)))
    
    if Metodo == "PCA"
        i = 1;
    else
        i = 12;
    end

    for d = 1:i                         % Derivaciones
        
        % Selección de la derivación
        der = Derivacion(d);
        
        for b = 1:length(Biomarcador)    % Biomarcadores

            % Selección del biomarcador
            bio = Biomarcador(b);
            
            for y = 1:length(Dictionary)
                % Existe el biomarcador en el año inicial y pasados 2 años
                if isfield(Paciente_Bio, Dictionary(y)) && ...
                        ~isempty (Paciente_Bio.InitialYear.(der).(bio)) && ...
                        ~isempty (Paciente_Bio.(Dictionary(y)).(der).(bio))
                    try
                        % Se agrupan todos los biomarcadores de los pacientes
                        Agrupamientos.("InitialYear_" + y).(der).(bio)(end+1) = Paciente_Bio.InitialYear.(der).(bio);
                        Agrupamientos.(Dictionary(y)).(der).(bio)(end+1) = Paciente_Bio.(Dictionary(y)).(der).(bio);

                    catch
                        % Se agrupan todos los biomarcadores de los pacientes
                        Agrupamientos.("InitialYear_" + y).(der).(bio)(1) = Paciente_Bio.InitialYear.(der).(bio);
                        Agrupamientos.(Dictionary(y)).(der).(bio)(1) = Paciente_Bio.(Dictionary(y)).(der).(bio);
                    end

                    % Registro de etiquetas
                    try
                        Registro.("reg"+y) = strcat(Registro.("reg"+y), ',' + bio);
                    catch
                        Registro.("reg"+y) = bio;
                    end
                end
            end

            % % Existe el biomarcador en el año inicial y pasados 4 años
            % if isfield(Paciente_Bio,"InitialYear_plus_4") && ...
            %         ~isempty (Paciente_Bio.InitialYear.(der).(bio)) && ...
            %         ~isempty (Paciente_Bio.InitialYear_plus_4.(der).(bio))
            %     try
            %         % Se agrupan todos los biomarcadores de los pacientes
            %         Agrupamientos.InitialYear_4.(der).(bio)(end+1) = Paciente_Bio.InitialYear.(der).(bio);
            %         Agrupamientos.Year_plus_4.(der).(bio)(end+1) = Paciente_Bio.InitialYear_plus_4.(der).(bio);
            % 
            %     catch
            %         % Se agrupan todos los biomarcadores de los pacientes
            %         Agrupamientos.InitialYear_4.(der).(bio)(1) = Paciente_Bio.InitialYear.(der).(bio);
            %         Agrupamientos.Year_plus_4.(der).(bio)(1) = Paciente_Bio.InitialYear_plus_4.(der).(bio);
            %     end
            % 
            %     % Registro de etiquetas
            %     try
            %         Registro.reg4{d} = strcat(Registro.reg4{d}, ',' + bio);
            %     catch
            %         Registro.reg4{d} = bio;
            %     end
            % end
        end
    end
end
end
