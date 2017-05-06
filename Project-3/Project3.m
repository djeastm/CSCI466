clear; clc; close all;
datasetNames = {
    'Five_Clust'};
methods = {'kmeans'};
indexTypes = {'di','pc','ce','fhv','cs'};
numClusters = [5];
visualize = 'true';
visible = 'false';
VATAndiVAT = 'false';

filename = strcat(char(cell2mat(datasetNames)),'.csv');
fileID = fopen(filename,'w');
for n=1:size(datasetNames,2);
for i=1:size(methods,2)    
    if strcmp(methods{i},'kmeans')
        fuzzifiers = [1]; 
        distMeasures = {'euclidean','manhattan'};   
    else
        fuzzifiers = [2];
        distMeasures = {'euclidean','manhattan','gkdistance'};
    end
    for j=1:size(distMeasures,2)            
    for f=1:size(fuzzifiers,2)                
    for c=1:size(numClusters,2)                    
        [clusters{c}, U{c}, dataset] = RunExperiment(...
            datasetNames{n},...
            methods{i},...
            distMeasures{j},...                 
            numClusters(c),...
            fuzzifiers(f),...
            visualize,...
            visible,...
            VATAndiVAT);                    
    end
    for k=1:size(indexTypes,2)                                    
        fprintf(fileID,'%s,%s,%s,%s,%d,',datasetNames{n},...
        methods{i}, distMeasures{j}, indexTypes{k},...
        fuzzifiers(f)); 
        for c=1:size(numClusters,2)
            indexScore = RunIndex(char(indexTypes{k}),...
            dataset, clusters{c}, U{c}', fuzzifiers(f));
            fprintf(fileID,'%f,', indexScore);                        
        end
        fprintf(fileID,'\n');           
    end            
    end
    end    
end
end
fclose(fileID);
