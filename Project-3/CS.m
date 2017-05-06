function [ score ] = CS( data, centers, U)
%CS Returns the CS index score for this clustering
numClusters = size(data,2);
maxDataPtDistSum = 0;
minClustDistSum = 0;
maxU = max(U,[],2);
for i=1:numClusters
    dataPtsInClust = data(U(:,i) == maxU,:);
    numDataPtsInClust = size(dataPtsInClust,1);
    maxDistDataPts = max(distmeasure(dataPtsInClust,dataPtsInClust,'euclidean'));
    numeratorTerm = sum(maxDistDataPts)/numDataPtsInClust;
    %the average largest distance between two data
    %points lying in the same cluster,
    v_i = sum(dataPtsInClust)/numDataPtsInClust;    
    distances = distmeasure(v_i, centers,'euclidean');
    % remove this cluster's center from consideration for the min
    distances(i) = double(intmax);
    denomTerm = min(distances);
    maxDataPtDistSum = maxDataPtDistSum + numeratorTerm;
    minClustDistSum = minClustDistSum + denomTerm;
end
score = maxDataPtDistSum/minClustDistSum;
end

