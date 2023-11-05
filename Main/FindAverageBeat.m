%% **********BÚSQUEDA DEL LATIDO PROMEDIO********** %%
function [latidopromediado, Registro] = FindAverageBeat(inputdir, ...
    paciente, fecha, process, method, corx, type)

%% INICIALIZACIÓN DE PARÁMETROS
latidopromediado = {};
% Registro de resultados
Registro.reg1 = false;
Registro.reg2 = false(1,12);
% Representación gráfica
tamano=get(0,'ScreenSize');
figure('name',[paciente '_' fecha '_' method '   BEATS & AVERAGE BEAT'], ...
    'NumberTitle','off', 'position',[tamano(1) tamano(2) tamano(3) tamano(4)]);

%% CARGAR PARÁMETROS

[HEADER,sinal,position,positionSLR] = FilesLoad(process, inputdir, paciente, fecha, method);
% Comprobación de los parámetros
if isempty (HEADER) || isempty (sinal) || isempty (position)
    % Si faltan datos, finaliza la ejecución de esta función
    Registro.reg1 = true;
    Registro.reg2(:) = false;
    return
end

%% BÚSQUEDA DEL LATIDO PROMEDIO
% FILTRADO DE LA DELINEACIÓN PREVIA
[filteredtags] = DelineationFilter(sinal,position,positionSLR,method);

for d = 1:12    % Derivaciones

    % Selección de la derivación correspondiente
    der=strrep(string(HEADER.desc(d,:)),' ','');
    derivacion = sinal(d,:);
    
    % Selección de los tags
    tags = filteredtags(d);

    % Evaluar la existencia de picos R
    if ~isfield(tags, 'qrs') || isempty(tags.qrs) || isnan(all(tags.qrs))
        continue
    end

    % CÁLCULO DE ANCHO DE VENTANA
    try
        % Duracion máxima del intervalo QRSon-R y R-QRSoff
        limit.N1 = round(max(tags.qrs - tags.qrson)) + 200;  % PQ fisiológico(200) 
        limit.N2 = round(max(tags.qrsoff - tags.qrs)) + 400; % QT fisiológico(400)
        if isnan(limit.N1) && ~isnan(limit.N2)
            limit.N1 = 250; % PQ fisiológico(200) + QR (~50)
        elseif isnan(limit.N2) && ~isnan(limit.N1)
            limit.N2 = 450; % QT fisiológico(400) + QR (~50)
        elseif isnan(limit.N2) && isnan(limit.N1)
            limit.N1 = 250; % PQ fisiológico(200) + QR (~50)
            limit.N2 = 450; % QT fisiológico(400) + QR (~50)
        end
        % Duración máxima de la ventana "fija"
        N = limit.N1 + limit.N2;
        M = length(tags.qrs);
    
        % EXTRACCIÓN DE LATIDOS
        % Matriz (de ceros) que contendrá info de cada latido
        realizaciones=zeros(M,N);
        % realizaciones=zeros(M-1,N);     
    catch
    end
    
    % Búsqueda en cada latido
    try     % Se pretende sacar cada uno de los latidos en la ventana establecida
        for b=1:M
            try
                realizaciones(b,:)=derivacion(tags.qrs(b) - limit.N1 ...
                    : tags.qrs(b) + limit.N2 - 1);
            catch   % Si faltasen datos, el latido queda descartado
                continue
            end
        end
    catch   % Si faltasen datos, la derivación queda descartada
        continue
    end

    % CORRELACIÓN CRUZADA DE LOS LATIDOS
    if corx == true
        % [latidos1] = BeatDefinition(realizaciones,derivacion,tags,method, limit);
        % [latidos2] = BeatDefinition(latidos1,derivacion,tags,method, limit);
        % [latidos] = BeatDefinition(latidos2,derivacion,tags,method, limit);

        [latidos] = BeatDefinition(realizaciones,derivacion,tags,method, limit);
    % SIN CORRELACIÓN CRUZADA
    else   
        latidos = realizaciones;
    end
    
    latidosqrs = limit.N1 + 1;
    latidosqrson = limit.N1 + 1 - (tags.qrs - tags.qrson);
    latidosqrsoff = limit.N1 + 1 + (tags.qrsoff - tags.qrs);


%%  CÁLCULO DEL LATIDO PROMEDIADO
    if exist('latidos','var') && ~isempty(latidos)
        
    % MEDIA de todos los latidos    
        if type == "mean"
            AverageECG = mean(latidos);     
        
    % MEDIANA de todos los latidos
        elseif type == "median"
            AverageECG = median(latidos);
            Averageqrs = round(median(latidosqrs));
            Averageqrson = round(median(latidosqrson));
            Averageqrsoff = round(median(latidosqrsoff));
            
        end
        % Se guarda el latido promediado con su nombre correspondiente
        % Importante, se eliminan espacios para no dar error
%         beats.(der) = latidos;
        % latidopromediado.(der) = AverageECG;
        latidopromediado.(der).sinal = AverageECG;
        latidopromediado.(der).qrs = Averageqrs;
        latidopromediado.(der).qrson = Averageqrson;
        latidopromediado.(der).qrsoff = Averageqrsoff;

        % Registro de resultados
        Registro.reg2(d) = true;
    end

%% REPRESENTACIÓN GRÁFICA
    if exist('AverageECG','var') && ~isempty(AverageECG)
        subplot(4,3,d);
        % Se representan todos los latidos y el promediado
        plot(AverageECG,'lineWidth',(3/2),'Color','r')
        hold on;
        try
            plot(Averageqrs, AverageECG(Averageqrs), 'pb')
            plot(Averageqrson, AverageECG(Averageqrson), 'ok')
            plot(Averageqrsoff, AverageECG(Averageqrsoff), 'ok')
        catch
        end
        hold on;
        plot(latidos'), xlim([0 inf]); %xlim auto
        title('Beats & Average Beat. Der ' + der),
        ylabel('Potential (mV)'), xlabel('Time (ms)'),
        legend('Latido promediado');
    end 

%% LIMPIEZA DE VARIABLES
    clear N1 N2 N M realizaciones latidos latidosqrs latidosqrson latidosqrsoff
    clear AverageECG Averageqrs Averageqrson Averageqrsoff
end
end