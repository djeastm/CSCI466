function [] = PlotData(id, Data, Labels, supportData, misclassedSamples,...
    numSVsPerFold, timePerFold)
%PLOTDATA Plots data

gscatter(Data(:,1),Data(:,2),Labels,'br','.')
hold on
title(id);
dim = [.7 .3 .1 .1];
str = strcat('Num Misclassed: ',num2str(size(misclassedSamples(:,1),1)));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.7 .2 .1 .1];
str = strcat('Num SVs: ',num2str(size(supportData(:,1),1)));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.7 .4 .1 .1];
if (strfind(id,'3fold'))
    str = strcat('Num SVsPerFold: ',num2str(numSVsPerFold));
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
end
plot(supportData(:,1),supportData(:,2),'ko')
if size(misclassedSamples(:,1),1) > 0;
    plot(misclassedSamples(:,1),misclassedSamples(:,2),'kx','MarkerSize',15)
end
legend('-1','+1','Support Vector', 'Misclassed','Location','NorthEastOutside')
hold off
print(id,'-dpng');
close
end

