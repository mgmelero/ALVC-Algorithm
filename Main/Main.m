%% ***** MAIN: IDENTIFICACIÓN DE BIOMARCADORES EN LA SEÑAL REPLICADA SL / SLR ***** %%

%% SELECCIÓN DE PARÁMETROS INICIALES
% [Metodo,Proceso,~,~] = Method;       % Selección manual
% IDENTIFICACIÓN DE PROCESAMIENTO
Metodo = 'SL';    % Selección: SL ~ SLR
Proceso = 2;      % Rango:      1 ~ 5   [Avr. Beat, Reply Avr. Beat, Tags, Biomarkers, PCA]
    % Si se escoge el proceso 1
Corx = true;      % Selección: true / false
Type = 'median';  % Selección: mean / median
Delineation = 1;  % Rango:      1 ~ 2   [Without PCA, With PCA]
% IDENTIFICACIÓN DE LOS DIRECTORIOS DE TRABAJO


% Directorio de la base de datos
Path_input = 'C:\TFM_matlab\DataBase';             
% Directorio para guardar los resultados
Path_output = ['C:\TFM_matlab\' Type '_' char(string(Corx)) '\Resultados'];   
% Directorio para guardar los registros
Path_register = ['C:\TFM_matlab\' Type '_' char(string(Corx)) '\Registro'];
% GENERALIZACIÓN DE RESULTADOS
Agrupamientos = {};
Diccionario = ["LatidoPromediado", "SenalPromediada", "Tags", "BioMarcadores", "PCA"];
T = table();


%% BÚSQUEDA POR PACIENTE Y FECHA DE PRUEBA
% Base de datos de todos los pacientes
Paciente = dir(Path_input); 

% Selección iD por paciente
for iD = 1:length(Paciente)
    % Base de datos de todas las pruebas
    FechaPrueba = dir([Path_input '\' Paciente(iD).name]);
    % Se resetea del primer año de cada paciente (Case 5)
    Registro.detected_year = true;

% Selección por fecha de prueba
    for iP = 1:length(FechaPrueba)
     

%% VALIDACIÓN DEL DIRECTORIO DE CARPETAS
        [NoDirectory, outputdir, inputdir] = FolderTest(Path_input, ...
            Path_output,Paciente(iD).name,FechaPrueba(iP).name);
        % Si no es válida la carpeta, continua al siguiente registro
        if NoDirectory  
            continue
        end


%% PROGRAMA PRINCIPAL
        switch Proceso
            case 1  % Obtención del latido promediado
                [LatidoPromediado, Registro] = FindAverageBeat(inputdir, ...
                    Paciente(iD).name, FechaPrueba(iP).name, Proceso, Metodo, ...
                    Corx, Type);
                Result = LatidoPromediado;

            case 2  % Obtención de la señal promediada
                [SenalPromediada, Registro] = ReplicatedAverageBeat(inputdir, ...
                    Paciente(iD).name, FechaPrueba(iP).name, Proceso, Metodo);
                Result = SenalPromediada;

            case 3  % Obtención de etiquetas ECG
                [Tags, Registro] = FindTagsInReplicatedAverageBeat(inputdir, ...
                    Paciente(iD).name, FechaPrueba(iP).name, Proceso, ...
                    Metodo, Delineation);
                Result = Tags;

            case 4  % Obtención de biomarcadores
                [BioMarcadores, Registro] = Biomarkers(inputdir, ...
                    Paciente(iD).name, FechaPrueba(iP).name, Proceso, ...
                    Metodo, Delineation);
                Result = BioMarcadores;

            case 5 % Obtención de PCA
                [PCA, Registro] = PCASinal(inputdir, Paciente(iD).name, ...
                    FechaPrueba(iP).name, Proceso, Metodo);
                Result = PCA;

        end


%% REGISTRO DE LOS DATOS OBTENIDOS
        % Se extrae el registro en el formato de la tabla
        [t] = DataRegister(Paciente(iD).name, FechaPrueba(iP).name, Proceso, Registro);
        % Se inserta una nueva fila de registro
        T = [T; t];


%% SALVAR LOS RESULTADOS
        % % Guardar los datos
        % if exist ('Result','var') && Proceso == 5
        %     save ([Paciente(iD).name '_' FechaPrueba(iP).name '_' ...
        %         char(string(Proceso)) '_' char(Diccionario(Proceso)) ...
        %         '.mat'], char(Diccionario(Proceso)));
        % 
        % elseif exist ('Result','var') && Proceso > 2 && Delineation == 2
        %     save ([Paciente(iD).name '_' FechaPrueba(iP).name '_' ...
        %         char(string(Proceso)) '_' char(Diccionario(Proceso)) ...
        %         '_PCA.mat'], char(Diccionario(Proceso)));
        % 
        % elseif exist ('Result','var')
        %     save ([Paciente(iD).name '_' FechaPrueba(iP).name '_' ...
        %         char(string(Proceso)) '_' char(Diccionario(Proceso)) ...
        %         '_' Metodo '.mat'], char(Diccionario(Proceso)));
        % end

        % Guardar las imágenes
        if (Proceso < 4 && Delineation == 1) || Proceso == 5
            saveas (1,['Images\' Paciente(iD).name '_' ...
                FechaPrueba(iP).name '_' char(string(Proceso)) '_' ...
                char(Diccionario(Proceso)) '_' Metodo],'png');

        elseif Proceso < 4 && Delineation == 2
            saveas (1,['Images\' Paciente(iD).name '_' ...
                FechaPrueba(iP).name '_' char(string(Proceso)) '_' ...
                char(Diccionario(Proceso)) '_PCA'],'png');
        end

        % IndicAdor de realización en Command Window
        indicador = ([Paciente(iD).name '_' FechaPrueba(iP).name ' Well Done'])


%% LIMPIEZA DE VARIABLES
        clear LatidoPromediado SenalPromediada Tags BioMarcadores PCA Result
        clear Registro.reg1 Registro.reg2 t
        close all
    end
    clear Registro
end


%% EXPORTACIÓN DE LA TABLA DE REGISTRO
if ~isfolder(Path_register) % Se crea una carpeta nueva si no existe.
    mkdir(Path_register);
end
% Se define el nombre de la tabla
if Delineation == 2 && (Proceso == 3 || Proceso == 4)
    name_reg = [Path_register '\' char(string(Proceso)) '_' ...
        char(Diccionario(Proceso)) '_PCA.txt'];
else
    name_reg = [Path_register '\' char(string(Proceso)) '_' ...
        char(Diccionario(Proceso)) '_' Metodo '.txt'];
end
% Se guarda la tabla
writetable(T,name_reg,'Delimiter' ,'\t','WriteRowNames',true);

clear all;