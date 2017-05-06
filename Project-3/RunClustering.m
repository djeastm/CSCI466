function [ clusters, U ] = RunClustering(dataset, numClusters, method, distMeasure,...
    fuzzifier)
%RunClustering Runs the selected clustering algorithm and returns the
%clusters and the membership matrix U

switch method
    case 'kmeans'
        [clusters, U] = RunKMeans(dataset, numClusters, distMeasure);        
    case 'fcm'        
        [clusters, U] = RunFCM(dataset, numClusters, distMeasure, fuzzifier);
end
end

function [clusters, U, dataset] = RunExperiment(datasetName, method, distMeasure,...
    numClusters, fuzzifier, visualize, visible, VATAndiVAT)
%RunExperiment Runs a clustering experiment and returns the clusters,
% a membership matrix, and indexScores for various clustering validity
% indices

%% Load Dataset
dataset = LoadDataSet(datasetName);

%% Run Clustering Algorithm
[clusters, U] = RunClustering(dataset, numClusters, method, distMeasure, fuzzifier);

%% Visualize
if strcmp(visualize, 'true')
    datasetName = strrep(datasetName, '_', '-');
    id = strcat(datasetName,'-',method,'-',distMeasure,...
        '-',int2str(fuzzifier),'-',int2str(numClusters)); 
    Visualize(id,dataset, clusters, U, visible, VATAndiVAT);
end

end
