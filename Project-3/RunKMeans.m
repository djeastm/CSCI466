function [clusters, U] = RunKMeans(data, numClusters, distMeasure)
%RUNKMEANS Runs the k-means clustering algorithm and returns the clusters 
% and the membership matrix U
N = size(data,1);
maxIterations = 100;
TOL = 1e-5;	
dataClusters = zeros(N,1);
% Start with a random cluster locations 
clusters = max(max(data)).*rand(numClusters,size(data,2));
for i=1:maxIterations
    oldClusters = clusters;    
    dist = distmeasure(clusters,data,distMeasure);
    [~, dataClusters] = min(dist);
    % get mean of all data points of each cluster so far
    for j=1:numClusters
        clusterDataIndices = (dataClusters==j);
        if sum(clusterDataIndices)~=0                 
            clusters(j,:) = sum(data(clusterDataIndices,:))/sum(clusterDataIndices);
        end
    end  
    if i > 1
        if abs(clusters - oldClusters) < TOL
            break; 
        end
    end
end
U = zeros(numClusters, N);
    for j=1:N;
        U(dataClusters(j),j) = 1;
    end
end
   
