%% **********REPLICACIÓN DEL LATIDO PROMEDIADO********** %%
function [senalpromediada, Registro] = ReplicatedAverageBeat(inputdir, ...
    paciente, fecha, process, method)

%% INICIALIZACIÓN DE PARÁMETROS
senalpromediada = {};
% Registro de resultados
Registro.reg1 = false;
Registro.reg2 = strings(1,12);
% Representación gráfica
tamano=get(0,'ScreenSize');
figure('name',[paciente '_' fecha '_' method '   REPLICATED AVERAGE BEAT'],...
    'NumberTitle','off', 'position',[tamano(1) tamano(2) tamano(3) tamano(4)]);

%% CARGAR PARÁMETROS
[HEADER,latidopromediado,~,~] = FilesLoad(process, inputdir, paciente, ...
    fecha, method);
% Comprobación de los parámetros
if isempty (HEADER) || isempty (latidopromediado)
    % Si faltan datos, finaliza la ejecución de esta función
    Registro.reg1 = true;
    Registro.reg2(:) = "--";
    return
end

%% BÚSQUEDA DEL LATIDO PROMEDIO
for d = 1:12    % Derivaciones
    
    % Selección de la derivada correspondiente
    der=strrep(string(HEADER.desc(d,:)),' ','');
    
    %Selección de método
    try
%%%%%%%%%%%%%% (comentado 21/7/23) %%%%%%%%%%%%%%
    % AMPLIACIÓN DEL LATIDO PROMEDIADO
        % Para la unión entre latidos, se calcula la diferencia entre el
        % primer y último valor del latido y se insertan 50 muestras
        dif=linspace(latidopromediado.(der).sinal(end),latidopromediado.(der).sinal(1),100);
        % Se amplía el latido promediado antes de replicarlo
        senalpromediada.(der)=[dif latidopromediado.(der).sinal];

    % REPLICACIÓN DE LATIDOS PROMEDIADOS 
        for r = 1:5         % Selección de replicación para generar 32 latidos 

            senalpromediada.(der) =[senalpromediada.(der) senalpromediada.(der)];
        end
%%%%%%%%%%%%%% (modificación 21/7/23) %%%%%%%%%%%%%%
%         dif=linspace(latidopromediado.(der).sinal(1),latidopromediado.(der).sinal(1),1000);
%         dif1=linspace(latidopromediado.(der).sinal(end),latidopromediado.(der).sinal(end),1000);
% 
%         senalpromediada.(der)=[dif latidopromediado.(der).sinal dif1];
%%%%%%%%%%%%%% (21/7/23) %%%%%%%%%%%%%%

        % Registro de errores
        Registro.reg2(d) = true;
    catch
        continue
    end

%% REPRESENTACIÓN GRÁFICA
    subplot(4,3,d);
    % Se representan todos los latidos replicados
    plot(senalpromediada.(der),'Color','b'), 
    % xlim([0 10000]);    % Intervalo de 10 segundos
    xlim([0 length(senalpromediada.(der))]);
    title('Replicated Average Beat. Der ' + der),
    ylabel('Potential (mV)'),
    xlabel('Time (ms)'), legend('Señal promediada');

%% LIMPIEZA DE VARIABLES
    clear dif dif1
end
end