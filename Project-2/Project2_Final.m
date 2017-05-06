clc; clear; close all;
%% Select Options

dataset = 2;
methods = {'resub','3fold'};  % 'resub' or '3fold'
kernelTypes = {'poly', 'rbf'}; % poly, rbf, tanh, dot
Cvals = [10,100,1000]; % 10, 100, 1000
RunLabels = {};

% to reduce number of samples to a reasonable size
reducePoints = true; 
% experimental option for randomizing the dataset before training
randomizeFirst = false;

% Run all permutations of the above options
r = 1; % Run number
for m=1:size(methods,2)
    for k=1:size(kernelTypes,2);
        for c=1:size(Cvals,2);
            method = methods{m};
            kernelType = kernelTypes{k}; 
            Cval = Cvals(c); 
            RunLabels(r) = strcat(method,{'-'},kernelType,{'-'},num2str(Cval));

            % Run SVM
            [Data{r}, Labels{r}, SVs{r}, misclassedSamples{r},...
                errorRate{r}, confusionMatrix{r},...
                timePerFold{r}, numSVsPerFold{r}] =...
                RunSVM(dataset, method, kernelType, Cval, reducePoints, randomizeFirst);

            if strcmp(method, '3fold')
                %% Calculate average error rate over the 3 folds
                averageErrorRate{r} = mean(cell2mat(errorRate(r))); 
            end
            
            % Plot Data
            datasetName = strcat('data',num2str(dataset),'-');
            PlotData(strcat(datasetName,RunLabels{r}), Data{r}, Labels{r}, SVs{r}, misclassedSamples{r}, numSVsPerFold{r}, timePerFold{r});

            r = r + 1;
        end
    end
end


%% Export Data
dlmwrite('results.txt',[]);
for r=1:r-1  
    fileID = fopen('results.txt','a');
    fprintf(fileID,'\n\n----------------------------------------\n');
    fprintf(fileID,'%s %s %s\n', RunLabels{r});
    fprintf(fileID,'\nError Rate\n');
    dlmwrite('results.txt',errorRate(r)','precision','%.2f','-append',...
'delimiter',',','roffset',1); 
    if size(misclassedSamples{r},1) > 0
        fprintf(fileID,'\nMisclassed Samples:');
        dlmwrite('results.txt',misclassedSamples(r)','precision','%.4f','-append',...
    'delimiter',',','roffset',1); 
    else
        fprintf(fileID,'\nMisclassed Samples: 0\n');
    end
fprintf(fileID,'\nConfusion Matrix');
    dlmwrite('results.txt',confusionMatrix(r)','precision','%d','-append',...
'delimiter',',','roffset',1);
    if size(numSVsPerFold{r}',1) > 0
        fprintf(fileID,'\nNumber of Support Vectors: ');
        dlmwrite('results.txt',numSVsPerFold(r)','precision','%d','-append',...
        'delimiter',',','roffset',1);
        fprintf(fileID,'\nSupport Vectors');
        dlmwrite('results.txt',SVs(r)','precision','%.4f','-append',...
        'delimiter',',','roffset',1);
    else
        fprintf(fileID,'\nNumber of Support Vectors: 0\n');
    end
    fprintf(fileID,'\nQuadProg Time: ');
        dlmwrite('results.txt',timePerFold(r)','precision','%.4f','-append',...
        'delimiter',',','roffset',1);
    fclose(fileID);
end