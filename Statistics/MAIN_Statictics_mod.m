%% *****MAIN: IDENTIFICACIÓN DE TAGS EN LA SEÑAL REPLICADA SL***** %%

%% SELECCIÓN DE PARÁMETROS INICIALES
% IDENTIFICACIÓN DE PROCESAMIENTO
Metodo='SL';    % Selección del método (SL / SLR / PCA)
% IDENTIFICACIÓN DE LOS DIRECTORIOS DE TRABAJO
Path_input = 'C:\TFM_matlab\DataBase';                  % Directorio de la base de datos
Path_output = 'C:\TFM_matlab\median_true\Resultados';       % Directorio para guardar los resultados
Path_statistics = 'C:\TFM_matlab\median_true\Estadistica_mod';  % Directorio para guardar los resultados estadísticos
% Path_output = 'C:\TFM_matlab\Mediana_CorX\Resultados';       % Directorio para guardar los resultados
% Path_statistics = 'C:\TFM_matlab\Mediana_CorX\Estadistica';  % Directorio para guardar los resultados estadísticos

% INICIALIZACIÓN DE VARIABLES
% Variable de agrupamiento
Agrupamientos = [];
% Tabla de registro
T = table();



%% BÚSQUEDA POR PACIENTE Y FECHA DE PRUEBA
% Base de datos de todos los pacientes
Paciente = dir(Path_output);

% Selección iD por paciente
for iD = 1:length(Paciente)
    % Base de datos de todas las pruebas
    FechaPrueba = dir([Path_output '\' Paciente(iD).name]);

    a1 = Paciente(iD).name

    % Al cambiar de paciente, la primera prueba a continuación es la prueba
    % inicial cuando le detectaron al paciente la patología
    first_date = true;

% Selección iP por fecha de prueba
    for iP = 1:length(FechaPrueba)
        a2 = FechaPrueba(iP).name;
     

%% VALIDACIÓN DEL DIRECTORIO DE CARPETAS
        [NoDirectory, outputdir, inputdir] = FolderTest(Path_input, ...
            Path_output,Paciente(iD).name,FechaPrueba(iP).name);
        % Si no es válida la carpeta, continua al siguiente registro
        if NoDirectory  
            continue
        end
        
        
%% AGRUPAMIENTOS POR AÑOS
        % Año de la prueba que se está evaluando
        year = str2double(FechaPrueba(iP).name(1:4));

        % Primer año del paciente con la patología
        if first_date 
            % Los siguientes años ya no serán el año inicial
            first_date = false;
            % Primer año cuando se detecta la patología
            YearPathologyWasDetected = year;
            % Identificación de la prueba evaluada
            group = "InitialYear";
            Registro.Year0 = FechaPrueba(iP).name;
        
        % Primera prueba pasados 1 años 
        elseif year - YearPathologyWasDetected == 1 && group ~= "InitialYear_plus_1"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_1";
            Registro.Year1 = FechaPrueba(iP).name;

        % Primera prueba pasados 2 años 
        elseif year - YearPathologyWasDetected == 2 && group ~= "InitialYear_plus_2"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_2";
            Registro.Year2 = FechaPrueba(iP).name;

        % Primera prueba pasados 3 años 
        elseif year - YearPathologyWasDetected == 3 && group ~= "InitialYear_plus_3"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_3";
            Registro.Year3 = FechaPrueba(iP).name;

        % Primera prueba pasados 4 años 
        elseif year - YearPathologyWasDetected == 4 && group ~= "InitialYear_plus_4"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_4";
            Registro.Year4 = FechaPrueba(iP).name;

        % Primera prueba pasados 5 años 
        elseif year - YearPathologyWasDetected == 5 && group ~= "InitialYear_plus_5"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_5";
            Registro.Year5 = FechaPrueba(iP).name;

        % Primera prueba pasados más de 5 años 
        elseif year - YearPathologyWasDetected >= 6 && group ~= "InitialYear_plus_6"
            % Identificación de la prueba evaluada
            group = "InitialYear_plus_6";
            Registro.Year6 = FechaPrueba(iP).name;

        else
            continue
        end
         
        
%% CARGAR PARÁMETROS
        % [HEADER,~,Biomarkers,~] = FilesLoad(5, inputdir, Paciente(iD).name, FechaPrueba(iP).name, Metodo);
        [HEADER,~,Biomarkers,~,Resultados] = FilesLoad(6, inputdir, Paciente(iD).name, FechaPrueba(iP).name, Metodo, nan, Path_statistics);
        % Comprobación de los parámetros
        if isempty (HEADER) || isempty (Biomarkers)
            % Si faltan datos, finaliza la ejecución de esta función
            Registro.reg1 = true;
            continue
        else
            Registro.reg1 = false;
        end


%% EXTRACCIÓN DE BIOMARCADORES
        % Se extraen de forma individual los biomarcadores del paciente
        % según las pruebas realizadas
        BiomarcadoresPruebasPaciente.(group) = Biomarkers;
    end
    

%% AGRUPAMIENTO DE BIOMARCADORES    
    % Extracción de cada biomarcador por derivación entre los años evaluados
    if ~NoDirectory && exist("BiomarcadoresPruebasPaciente","var")
    %% Agrupamiento SIN PCA       
        % [Agrupamientos, Registro] = Grouping(BiomarcadoresPruebasPaciente, Agrupamientos, Registro);
    %% Agrupamiento CON PCA
        [Agrupamientos, Registro] = Grouping_pca_mod(BiomarcadoresPruebasPaciente, Agrupamientos, Registro, Metodo);

    else
        continue
    end


%% REGISTRO DE LOS DATOS OBTENIDOS
    % % Se extrae el registro en el formato de la tabla
    % % [t] = DataRegister(Paciente(iD).name, nan, 5, Registro);
    % [t] = DataRegister(Paciente(iD).name, nan, 6, Registro);
    % % Se inserta una nueva fila de registro
    % T = [T; t];


%% LIMPIEZA DE VARIABLES
    clear group BiomarcadoresPruebasPaciente Registro
end


%% ESTADÍSTICAS DE LOS RESULTADOS SIN PCA      
% Estadisticas = Statistics(Agrupamientos);

%% ESTADÍSTICAS DE LOS RESULTADOS CON PCA      
[Estadisticas, Resultados, Resultados_n] = Statistics_pca_mod(Agrupamientos, Metodo, Resultados);


%% REGISTRO DE DATOS
if ~isfolder(Path_statistics) % Se crea una carpeta nueva si no existe.
    mkdir(Path_statistics);
end


%% SALVAR LOS RESULTADOS
save ([Path_statistics '\Agrupamientos_' Metodo '.mat'], "Agrupamientos");
save ([Path_statistics '\Statistics_' Metodo '.mat'], "Estadisticas");
save ([Path_statistics '\Resultados.mat'], "Resultados");


%% EXPORTACIÓN DE LA TABLA DE RESULTADOS
names = fieldnames(Resultados);
for m = 1:length(names)
    % Se define el nombre de la tabla
    name_res = strjoin(string([Path_statistics '\Results\Resultados.xlsx']), '');
    name_res2 = strjoin(string([Path_statistics '\Results\Resultados2.xlsx']), '');
    % Se guarda la tabla
    xlswrite(name_res, Resultados.(string(names(m))),string(names(m)));
    xlswrite(name_res2, Resultados_n.(string(names(m))),string(names(m)));
end

%% EXPORTACIÓN DE LA TABLA DE REGISTRO
% Se define el nombre de la tabla
name_reg = [Path_statistics '\Agrupamientos_' Metodo '.txt'];
% Se guarda la tabla
writetable(T,name_reg,'Delimiter' ,'\t','WriteRowNames',true);

clear all;