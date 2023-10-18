%% **********registro DE LOS RESULTADOS OBTENIDOS********** %%
function [t] = DataRegister(PACIENTE, FECHA, process, registro)

%% INICIALIZACIÓN DE PARÁMETROS
Diccionario = ["I", "II", "III", "aVL", "aVR", "aVF", "V1", "V2", "V3", "V4", "V5", "V6"];
t = table();

%% registro DE LOS DATOS
% Se recogen los datos que serán representados en la tabla
EXISTE_SENAL_ORIGEN = ~registro.reg1;
for d = 1:12

    if process < 5
        Der.(Diccionario(d)) = registro.reg2(d);
    else
        Der.(Diccionario(d)) = "--";
    end

    if process == 5 && isfield(registro,"Year2")
        Der2.(Diccionario(d)) = registro.reg2{d};
    end
    if process == 5 && isfield(registro,"Year4")
        try
            Der4.(Diccionario(d)) = registro.reg4{d};
        catch
            Der4.(Diccionario(d)) = "--";
        end
    end
end

if process == 5

    if isfield(registro,"Year0") && ...
            (isfield(registro,"Year2") || isfield(registro,"Year4"))
    % Se recogen los datos que serán representados en la tabla    
        FECHA = registro.Year0;
        DETECCION = true;
        INTERVALO_2 = "--";
        INTERVALO_4 = "--";

        %% CREACIÓN DE UNA TABLA PARA EL registro DE DATOS
        t = table (string(PACIENTE), string(FECHA), EXISTE_SENAL_ORIGEN, ...
            DETECCION, INTERVALO_2, INTERVALO_4, Der.I, Der.II, Der.III, ...
            Der.aVL, Der.aVR, Der.aVF, Der.V1, Der.V2, Der.V3, Der.V4, ...
            Der.V5, Der.V6);

    end
    
    if isfield(registro,"Year2")
        % Se recogen los datos que serán representados en la tabla    
        FECHA = registro.Year2;
        DETECCION = "--";
        INTERVALO_2 = true;
        INTERVALO_4 = "--";
        Der = Der2;

        %% CREACIÓN DE UNA TABLA PARA EL registro DE DATOS
        tabla = table (string(PACIENTE), string(FECHA), EXISTE_SENAL_ORIGEN, ...
            DETECCION, INTERVALO_2, INTERVALO_4, Der.I, Der.II, Der.III, ...
            Der.aVL, Der.aVR, Der.aVF, Der.V1, Der.V2, Der.V3, Der.V4, ...
            Der.V5, Der.V6);

        t = [t; tabla];
    end
    
    if isfield(registro,"Year4")
        % Se recogen los datos que serán representados en la tabla    
        FECHA = registro.Year4;
        DETECCION = "--";
        INTERVALO_2 = "--";
        INTERVALO_4 = true;
        Der = Der4;

        %% CREACIÓN DE UNA TABLA PARA EL registro DE DATOS
        tabla = table (string(PACIENTE), string(FECHA), EXISTE_SENAL_ORIGEN, ...
            DETECCION, INTERVALO_2, INTERVALO_4, Der.I, Der.II, Der.III, ...
            Der.aVL, Der.aVR, Der.aVF, Der.V1, Der.V2, Der.V3, Der.V4, ...
            Der.V5, Der.V6);

        t = [t; tabla];
    end

else
%% CREACIÓN DE UNA TABLA PARA EL registro DE DATOS
t = table (string(PACIENTE), string(FECHA), EXISTE_SENAL_ORIGEN, Der.I, ...
    Der.II, Der.III, Der.aVL, Der.aVR, Der.aVF, Der.V1, Der.V2, Der.V3, ...
    Der.V4, Der.V5, Der.V6);

end
end