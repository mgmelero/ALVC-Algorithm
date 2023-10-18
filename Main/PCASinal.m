%% **********REPLICACIÓN DEL LATIDO PROMEDIADO********** %%
function [senal_PCA, Registro] = PCASinal(inputdir, ...
    paciente, fecha, process, method)

%% INICIALIZACIÓN DE PARÁMETROS
senal_PCA = {};
% Registro de resultados
Registro.reg1 = false;
Registro.reg2 = strings(1,12);
% Representación gráfica
tamano=get(0,'ScreenSize');
figure('name',[paciente '_' fecha '_' method '   PCA Sinal'],...
    'NumberTitle','off', 'position',[tamano(1) tamano(2) tamano(3) tamano(4)]);

%% CARGAR PARÁMETROS
[HEADER,sinal,LatidoPromediado,~] = FilesLoad(process, inputdir, paciente, ...
    fecha, method);
% Comprobación de los parámetros
if isempty (HEADER) || isempty (LatidoPromediado)
    % Si faltan datos, finaliza la ejecución de esta función
    Registro.reg1 = true;
    Registro.reg2(:) = "--";
    return
end

%% BÚSQUEDA DE LA MATRIZ DEL COMPLEJO QRS DE LOS LATIDOS PROMEDIADOS 
%% DE CADA DERIVACIÓN
for d = 1:12
    if ~exist("on", "var") || ~exist("off", "var")
        der=strrep(string(HEADER.desc(d,:)),' ','');
        try
            on = LatidoPromediado.(der).qrson;
            off = LatidoPromediado.(der).qrsoff;
        catch
            continue
        end
    end
end
for d = 1:12
    der=strrep(string(HEADER.desc(d,:)),' ','');
    try
        QRS(d,:) = [LatidoPromediado.(der).sinal(1, on : off)];
    catch
        continue
    end
end


%% CÁLCULO DE PCA
% Calculamos los coeficientes [eigvectors, eigvalues]
[eigvectors, eigvalues] = eig(cov(QRS'));   
% Ordenamos la matrices en orden descendente
[~, order] = sort(diag(eigvalues), 'descend');  
eigvectors_order = eigvectors(:, order);
% Obtenemos la señal multiplicada por los coeficientes de PCA
senal_PCA = eigvectors_order'*sinal;


%% REPRESENTACIÓN GRÁFICA
% Se representan todos los latidos replicados
for d = 1:12
    der = strrep(string(HEADER.desc(d,:)),' ','');
    
    subplot(4,3,d);
    plot(senal_PCA(d,:), 'b'),
    hold on;
    plot(sinal(d,:),'k');
    xlim([0 length(sinal(d,:))]);
    title('PCA SINAL ' + der + 'VS SINAL ' + der),
    ylabel('Potential (mV)'),
    xlabel('Time (ms)'),
    legend("PCA SINAL","SINAL");


end