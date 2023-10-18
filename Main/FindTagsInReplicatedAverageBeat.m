%% **********BÚSQUEDA DE ETIQUETAS DEL ECG********** %%
function [Tags, Registro] = FindTagsInReplicatedAverageBeat(inputdir, ...
    paciente, fecha,  process, method, pca)

%% INICIALIZACIÓN DE PARÁMETROS
etiquetas = [];
Tags = {};
% Diccionario de los tags
labels = {'Pon';'P';'Poff';'qrs';'QRSon';'QRSoff';'Ton';'T';'Toff'};
QT_flag = 0;
Tpe_flag = 0;
% Registro de resultados
Registro.reg1 = false;
Registro.reg2 = strings(1,12); 
% Representación gráfica
tamano=get(0,'ScreenSize');
figure('name',[paciente '_' fecha '_' method '   FOUND TAGS'], ...
    'NumberTitle','off','position',[tamano(1) tamano(2) tamano(3) tamano(4)]);

%% CARGAR PARÁMETROS
[HEADER,senalpromediada,~,~] = FilesLoad(process, inputdir, paciente, ...
    fecha, method, pca);

% load ("pc.mat","pc"); % 280723
% senalpromediada = pc; % 280723
% Comprobación de los parámetros
if isempty (HEADER) || isempty (senalpromediada)
    % Si faltan datos, finaliza la ejecución de esta función
    Registro.reg1 = true;
    Registro.reg2(:) = "--";
    return
end


%% BÚSQUEDA Y EXTRACCIÓN DE ETIQUETAS
% Si la delineación es de PCA, sólo habrá que delinear la primera señal
if pca == 2
    i = 1;
else
    i = 12;
end

for d = 1:i    % Derivaciones

    % Selección de la derivada correspondiente y la posición en la gráfica
    der=strrep(string(HEADER.desc(d,:)),' ','');

    try
        if pca == 1
            subplot(4,3,d);
            % Se traspone filas por columnas
            sinal = senalpromediada.(der)';
        else
            % Se traspone filas por columnas
            % sinal = senalpromediada.(der)';
            sinal = senalpromediada(d,:)';
        end
   
        % Algoritmo wavedet para obtención de tags
        [~,~,~,~,tag] = ...
            del(HEADER.freq,sinal,inputdir,0,labels,QT_flag,Tpe_flag,HEADER);
        
        % Se guarda y organiza en una estructura
        Tags.(der)=tag;

%% VALIDACIÓN DE ETIQUETAS EXTRAÍDAS
        if ~isempty (tag.Pon)
            etiquetas = 'Pon,';
            plot(round(tag.Pon),sinal(tag.Pon),'ro'), hold on;
        end
        if ~isempty (tag.P)
            etiquetas = strcat(etiquetas, 'P,');
            plot(round(tag.P),sinal(tag.P),'rp'), hold on;
        end
        if ~isempty (tag.Poff)
            etiquetas = strcat(etiquetas, 'Poff,');
            plot(round(tag.Poff),sinal(tag.Poff),'ro'), hold on;
        end
        if ~isempty (tag.QRSon)
            etiquetas = strcat(etiquetas, 'QRSon,');
            plot(round(tag.QRSon),sinal(tag.QRSon),'go'), hold on;
        end
        if ~isempty (tag.qrs) || ~isempty (tag.R)
            etiquetas = strcat(etiquetas, 'qrs,');
            plot(round(tag.qrs),sinal(tag.qrs),'gp'), hold on;
        end
        if ~isempty (tag.QRSoff)
            etiquetas = strcat(etiquetas, 'QRSoff,');
            plot(round(tag.QRSoff),sinal(tag.QRSoff),'go'), hold on;
        end
        if ~isempty (tag.Ton)
            etiquetas = strcat(etiquetas, 'Ton,');
            plot(round(tag.Ton),sinal(tag.Ton),'mo'), hold on;
        end
        if ~isempty (tag.T)
            etiquetas = strcat(etiquetas, 'T,');
            plot(round(tag.T),sinal(tag.T),'mp'), hold on;
        end
        if ~isempty (tag.Toff)
            etiquetas = strcat(etiquetas, 'Toff,');
            plot(round(tag.Toff),sinal(tag.Toff),'mo'), hold on;
        end
        
        % Registro de etiquetas
        if ~isempty (etiquetas)            
            Registro.reg2(d) = etiquetas(1:end-1);
        else
            Registro.reg2(d) = "NO_TAGS";
        end
    
    catch
        Tags.(der)={};
        Registro.reg2(d) = "--";
        continue
    end

%% REPRESENTACIÓN GRÁFICA
    % Se representan todos los latidos replicados
    plot(sinal,'Color','b'), hold on,
    if ~isempty(find(~isnan(tag.Pon) & ~isnan(tag.Toff)))       % Rango de un latido
        ind = find(~isnan(tag.Pon) & ~isnan(tag.Toff));
        xlim([tag.Pon(min(ind)) tag.Toff(min(ind))]);
    elseif ~isempty(tag.R) && sum(tag.R(~isnan(tag.R))) > 1     % Ventana fija del ancho del pp
        dif_pp = median(diff(tag.R(~isnan(tag.R))));
        try
            xlim([(tag.R(2)-dif_pp*0.5) (tag.R(2)+dif_pp*0.5)]);
            % xlim([1 length(sinal)]);
        catch
            xlim([0 2000]);
        end
    else
        xlim([0 2000]);  % 2 segundos para obtener un latido completo
    end 
%     xlim([0 5000])  % 5 segundos 
    if pca == 1
        title('Found Tags in Average Sinal. Der ' + der);
    elseif pca == 2
        title('Found Tags in PCA Sinal. PC1');
    end
    ylabel('Potential (mV)'), xlabel('Time (ms)');

%% LIMPIEZA DE VARIABLES
    clear sinal etiquetas
    etiquetas=[]; 

end
end