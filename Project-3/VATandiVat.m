%% Load Dataset
datasetName = 'Three_Close_Clust';
dataset = LoadDataSet(datasetName);
datasetName = strrep(datasetName, '_', '-');    
D = pdist2(dataset,dataset);
[RV, C, I, RI] = VAT(D);
imagesc(RV, [0 max(max(RV))]);
title(datasetName);
datasetName = strrep(datasetName, '-', '_');
name = strcat(datasetName,'-VAT');
print(name,'-dpng');
figure,
[RiV, RV] = iVAT(D);
imagesc(RiV);
datasetName = strrep(datasetName, '_', '-'); 
title(datasetName);
datasetName = strrep(datasetName, '-', '_');
name = strcat(datasetName,'-iVAT');
print(name,'-dpng');
close all;