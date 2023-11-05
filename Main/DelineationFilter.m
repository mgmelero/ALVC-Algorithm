%% **********FILTRADO DE LA DELINEACIÓN********** %%
function [filteredtags] = DelineationFilter(sinal,position,positionSLR,method)

%% BÚSQUEDA DE TAGS POR DERIVCACIÓN
for d = 1:12    % Derivaciones
    
    % Inicialización de variables
    filteredtags(d).qrs = [];
    filteredtags(d).qrson = [];
    filteredtags(d).qrsoff = [];
    

    % Selección de los tags
    if method == "SLR"
        tags = positionSLR;
        tags2 = positionSLR;
    else
        if ~isempty(position{d,1}.qrs)
            tags = position{d,1};
        else
            tags = positionSLR;
        end
        if ~isempty(positionSLR)
            tags2 = positionSLR;
        else
            tags2 = position{d,1};
        end
    end

    % Evaluación de latidos válidos posibles
    % M = length(tags2.QRSon(~isnan(tags2.QRSon)));
    m = length(tags2.qrs);
    
    % Tendencia positiva o negativa
    % if sum(sinal(d,tags2.qrs) < 0) > sum(sinal(d,tags2.qrs) < 0)
    %     sig = false;
    % else
    %     sig = true;
    % end

    % ¿Qué ocurre en cada latido?
    for n = 1:m-1
        if isnan(tags2.QRSon(n))
            continue
        else
            on = tags2.QRSon(n);    % Valor de entrada
            on2 = tags2.QRSon(min(find(tags2.QRSon > on))); % Siguiente valor
            r = tags.qrs(min(find(tags.qrs > on))); % Valor de R perteneciente
            off = tags2.QRSoff(min(find(tags2.QRSoff > on))); % Valor de salida
            r_slr = tags2.qrs(min(find(tags2.qrs > on))); % Valor de R común

            if isempty(r) || isempty(off) || isempty(on2)
                continue

            elseif r < off && off < on2 && r_slr < off
                
                % [~, ind] = max(sinal(d, on:off));
                % [~, ind] = max(abs(sinal(d, on:off)));
                % if sig 
                %     [~, ind] = max(sinal(d, on:off));
                % else
                %     [~, ind] = min(sinal(d, on:off));
                % end

                % r2 = on + ind;
                % if abs(sinal(10, r2)) > abs(sinal(10, r))
                %     filteredtags(d).qrs(end+1) = r2;
                % else
                %     filteredtags(d).qrs(end+1) = r;
                % end
                filteredtags(d).qrs(end+1) = r;
                filteredtags(d).qrson(end+1) = r - (r_slr - on);
                filteredtags(d).qrsoff(end+1) = r + (off - r_slr);
            end
        end
    end

    % Se realiza estadística para sacar los latidos outliers 
    % (se utilizan valores absolutos)
    data = abs(sinal(d, filteredtags(d).qrs));
    media = mean(data);
    L1 = abs(media * 1.5);
    L2 = abs(media * 0.5);
    %s = std(data);

    m = length(data);
    fakebeat = [];

    % for n = 1:m
    %     if data(n) < L2 && data(n) < L1
    %         continue
    %     else
    %         fakebeat(end+1) = n;
    %     end
    % end
    % 
    % if ~isempty (fakebeat)
    %     filteredtags(d).qrs(fakebeat)=[];
    %     filteredtags(d).qrson(fakebeat)=[];
    %     filteredtags(d).qrsoff(fakebeat)=[];
    % end
end
