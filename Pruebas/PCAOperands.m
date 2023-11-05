% Asegurarnos de que los latidos estén por columnas (derivaciones) QRS -
% QRS'

load("header.mat",'HEADER');
load("p018_20150312_1_LatidoPromediado_SL.mat",'LatidoPromediado');
load("p018_20150312BRLPF.mat",'sinal');

for d = 1:12
    der=strrep(string(HEADER.desc(d,:)),' ','');
    on = LatidoPromediado.(der).qrson;
    off = LatidoPromediado.(der).qrsoff;
    QRS(d,:) = [LatidoPromediado.(der).sinal(1, on : off)];
end


[eigvectors,eigvalues]=eig(cov(QRS')); %% Calculamos los eigvectors,eigvalues
[~,order]=sort(diag(eigvalues),'descend'); %% Ordenamos la matrices en orden descendente
eigvectors_order = eigvectors(:,order);
% Asegurarnos de que los latidos estén por columnas o por filas (Puede
% existir fallo)
pc=eigvectors_order'*sinal;
%%Realizamos un plot de la PC1 vs la Derivación I
plot (pc(1,:));
hold on;
plot(sinal(1,:),'k');
title('PC I VS DERIVACION I');
legend("PC1","SINAL");

