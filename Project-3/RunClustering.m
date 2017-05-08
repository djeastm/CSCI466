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
