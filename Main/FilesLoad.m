%% **********CARGAR ARCHIVOS DE INTERÉS********** %% 
function [HEADER,sinal,Tags,Tags2, Resultados] = FilesLoad(process,inputdir,paciente, ...
    fecha,method,ispca, statdir)

%% INICIALIZACIÓN DE VARIABLES
HEADER=[];
sinal=[];
Tags=[];
Tags2=[];

%% ELECCIÓN DEL PROGRAMA
switch process
    % Se cargan archivos de la base de datos (iniciales)
    case 1      % Búsqueda latido promedio
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER'],'HEADER');
            load([inputdir '\' paciente '_' fecha 'BRLPF'],'sinal');
            load([inputdir '\' paciente '_' fecha 'positionSL'],'position');
            load([inputdir '\' paciente '_' fecha 'positionSLR'],'positionSLR');
            if contains(method,'SLR')
                Tags=positionSLR;
                Tags2=Tags;
            else
                Tags=position;
                Tags2=positionSLR;
            end
        catch
        end

    % Se cargan latidos promedio de la base de resultados
    case 2      % Replicación latido promediado
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER']);
            % Se cargan los latidos promediados
            load([paciente '_' fecha '_1_LatidoPromediado_' method]);
            sinal=LatidoPromediado;
        catch 
        end

    % Se cargan señales promedio de la base de resultados
    case 3      % Búsqueda de Tags en la Señal Promediada
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER']);
            
            if ispca == 1
                % Se cargan las señales replicadas
                load([paciente '_' fecha '_2_SenalPromediada_' method]);
                sinal=SenalPromediada;
            elseif ispca == 2
                load([paciente '_' fecha '_5_PCA']);
                sinal = PCA;
            end
        catch
        end

    % Se cargan las señales original y promediada y las etiquetas
    case 4      % Búsqueda de Biomarcadores y Estadística de los Resultados
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER']);
            load([inputdir '\' paciente '_' fecha 'position' method]);
            if contains(method,'SLR')
                Tags2=positionSLR;
            else
                Tags2=position;
            end
            % Se cargan las señales replicadas y los tags
            if ispca == 1
                load([paciente '_' fecha '_2_SenalPromediada_' method]);
                sinal=SenalPromediada;
                load([paciente '_' fecha '_3_Tags_' method]);

            elseif ispca == 2
                load([paciente '_' fecha '_5_PCA']);
                sinal=PCA;
                load([paciente '_' fecha '_3_Tags_PCA']);
            end
            
        catch
        end   

        
    case 5      % Cálculo de PCA
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER'],'HEADER');
            load([inputdir '\' paciente '_' fecha 'BRLPF'],'sinal');
            % Se cargan los latidos promediados
            load([paciente '_' fecha '_1_LatidoPromediado_' method]);
            
            Tags=LatidoPromediado;
        catch
        end


    case 6      % Estadística de los resultados
        try
            % Se cargan los archivos de información '.mat' 
            load([inputdir '\' paciente '_' fecha '_HEADER']);
            % Se cargan los latidos promediados
            load([paciente '_' fecha '_4_BioMarcadores_' method]);
            Tags = BioMarcadores;
            load([statdir '\Resultados']);

        catch
            Resultados = {};
        end
end
end