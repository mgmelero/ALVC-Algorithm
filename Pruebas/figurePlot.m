for d = 1:12

    figure
    subplot(2,1,1)
    plot(sinal(d,:))
    hold on
    plot(position{d,1}.qrs, sinal(d,position{d,1}.qrs), '*r');
    %plot(positionSLR.qrs, sinal(d,positionSLR.qrs), '*g');
    plot(positionSLR.QRSon(~isnan(positionSLR.QRSon)), sinal(d,positionSLR.QRSon(~isnan(positionSLR.QRSon))), 'ob');
    plot(positionSLR.QRSoff(~isnan(positionSLR.QRSoff)), sinal(d,positionSLR.QRSoff(~isnan(positionSLR.QRSoff))), 'ok');
    
    subplot(2,1,2)
    plot(pc(1,:))
    hold on
    plot(filteredtags(d).qrs, sinal(d,filteredtags(d).qrs), '*r');
    plot(filteredtags(d).qrson, sinal(d,filteredtags(d).qrson), 'ob');
    plot(filteredtags(d).qrsoff, sinal(d,filteredtags(d).qrsoff), 'ok');

    plot(Tags.I.qrs, pc(1,Tags.I.qrs), '*r');
    plot(Tags.I.R, pc(1,Tags.I.R), '*r');
    plot(Tags.I.QRSon, pc(1,Tags.I.QRSon), 'ob');
    plot(Tags.I.QRSoff, pc(1,Tags.I.QRSoff), 'ok');

end

