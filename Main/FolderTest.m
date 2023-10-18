%% **********EVADIR CARPETAS OCULTAS Y CREAR (SI ES NECESARIO) CARPETA DESTINO********** %%
function [nodirectory,outputdir,inputdir] = FolderTest(inroot,outroot,paciente,fecha)

% Diccionario de posibles subcarpetas no válidas
diccionario = [".", "..", ".DS_Store"];
outputdir = nan;
inputdir = nan;

try
    % Se localizan las carpetas que no nos interesan
    % y se continua a la siguiente carpeta
    if ~isempty(find(diccionario==paciente,1)) || ~isempty(find(diccionario==fecha,1))
        nodirectory = true;     % No es una carpeta válida.
    else
        nodirectory = false;    % Es una carpeta válida.
        % Se actualiza la carpeta de trabajo para cada paciente y cada fecha
        outputdir = [outroot, '\', paciente, '\', fecha];
        inputdir = [inroot, '\', paciente, '\', fecha];
    
        if ~isfolder(outputdir) % Se crea una carpeta nueva si no existe.
            mkdir(outputdir)
            mkdir([outputdir '\Images'])    % Se crea otra carpeta dentro para las imágenes
        end
        cd(outputdir)
    end

% Se verifica que la carpeta seleccionada no es un directorio válido.
catch
    nodirectory = true;         % No es una carpeta válida.
end
end