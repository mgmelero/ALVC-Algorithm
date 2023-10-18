function [QT,Tpe,QTV,TpeV,position,Indxs] = del(fa,sinal,curr_dir,pintar,labels,QT_flag,Tpe_flag,header)

sinal = sinal(1:end);
% if exist([curr_dir 'ecg.mat'],'file')
%     delete 'ecg.mat'
% end
%save([curr_dir 'ecg.mat'],'fa','sinal');
[position,~,~] = wavedet_3D(sinal,'',header,'');
Indxs = []; 
for ilabel = 1:length(labels)
    eval(['Ind_' labels{ilabel} ' = find(isnan(position.' labels{ilabel} ')==1);']);
    eval(['Indxs = union(Indxs,Ind_' labels{ilabel} ');']);
end
for ilabel = 1:length(labels)
    eval(['position.' labels{ilabel} '(Indxs) = [];']);
end


try
    if pintar
        figure,plot(sinal)
        hold on
        for imark = 1:length(position.Pon)
            plot(position.Pon(imark),sinal(position.Pon(imark)),'o')
        end
        for imark = 1:length(position.Toff)
            plot(position.Toff(imark),sinal(position.Toff(imark)),'o')
        end
        for imark = 1:length(position.T)
            plot(position.T(imark),sinal(position.T(imark)),'*')
        end
    end
catch me
    disp(me.message);
    try
        
        for imark = 1:length(position.QRSoff)
            plot(position.QRSoff(imark)+20*fa/1000,sinal(position.QRSoff(imark)+20*fa/1000),'o')
        end
        for imark = 1:length(position.Toff)
            plot(position.Toff(imark),sinal(position.Toff(imark)),'o')
        end
        for imark = 1:length(position.T)
            plot(position.T(imark),sinal(position.T(imark)),'*')
        end
    catch me2
        disp(me2.message)
    end
end
%--------------------------------
% Cálculo de las series
%--------------------------------
if QT_flag&&Tpe_flag
    if ~isempty(position.Toff)&&~isempty(position.QRSon)&&~isempty(position.T)
        QT = position.Toff - position.QRSon;
        Tpe = position.Toff - position.T;
        QTV = abs(QT-QT(1));
        TpeV = abs(Tpe-Tpe(1));
    else
        QT = NaN;
        Tpe = NaN;
        QTV = NaN;
        TpeV = NaN;
    end
else
    QT = NaN;
    Tpe = NaN;
    QTV = NaN;
    TpeV = NaN;
end
end
