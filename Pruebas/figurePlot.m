for d = 1:1

    figure
    % subplot(2,1,1)
    plot(sinal(d,:))
    hold on
    plot(PCA(d,:))
    % plot(position{d,1}.qrs, sinal(d,position{d,1}.qrs), '*r');
    % %plot(positionSLR.qrs, sinal(d,positionSLR.qrs), '*g');
    % plot(positionSLR.QRSon(~isnan(positionSLR.QRSon)), sinal(d,positionSLR.QRSon(~isnan(positionSLR.QRSon))), 'ob');
    % plot(positionSLR.QRSoff(~isnan(positionSLR.QRSoff)), sinal(d,positionSLR.QRSoff(~isnan(positionSLR.QRSoff))), 'ok');
    xlim([1000 9000]);
    title('Original Sinal vs Sinal With PCA'),
    ylabel('Potential (mV)'), xlabel('Time (ms)'),
    legend('Sinal (Der I)', '1PC sinal');

%     subplot(2,1,2)
%     plot(sinal(d,:))
%     hold on
% 
%     % plot(filteredtags(d).qrs, sinal(d,filteredtags(d).qrs), '*r');
%     % plot(filteredtags(d).qrson, sinal(d,filteredtags(d).qrson), 'ob');
%     % plot(filteredtags(d).qrsoff, sinal(d,filteredtags(d).qrsoff), 'ok');
% 
%     % plot(Tags.I.qrs, pc(1,Tags.I.qrs), '*r');
%     % plot(Tags.I.R, pc(1,Tags.I.R), '*r');
%     % plot(Tags.I.QRSon, pc(1,Tags.I.QRSon), 'ob');
%     % plot(Tags.I.QRSoff, pc(1,Tags.I.QRSoff), 'ok');
% 
%     xlim([1000 9000]);
%     title('Filtered Delineation'),
%     ylabel('Potential (mV)'), xlabel('Time (ms)'),
%     legend('Sinal (Der I)');
% 


saveas (1,['C:\Users\Miguel G Melero\Dropbox\VIU_MÁSTER\TFM\Entregas\Fase 2\Otras imágenes\p050_20200723_PCA1'],'png');

end

