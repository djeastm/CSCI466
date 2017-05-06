function [ indexScore ] = DUNN(data, centers, U)
%DUNN Compute Dunn's Index
numClusters = size(centers,1);
U = U';
maxU = max(U);
% Find max diameter
for i=1:numClusters
    index{i} = find(U(i,:) == maxU);
    clustPts = data(index{i},:); % all cluster points
    ptDist = pdist2(clustPts,clustPts);
    maxPtDist = max(max(ptDist));
    if isscalar(maxPtDist)
        diam(i,:) = maxPtDist;  %max intercluster diam for this cluster
    else 
        diam(i,:) = 0;
    end
end
maxDiam = max(diam);  %max intercluster diam of all clusters

for i=1:numClusters
    iter = 1;
    for j=i+1:numClusters
            ptDist = pdist2(data(index{i},:), data(index{j},:));
            minPtDist = min(min(ptDist));
            if isscalar(minPtDist)
                dissim(iter,:) = min(minPtDist/maxDiam);        
            else
                dissim(iter,:) = 0;        
            end
            iter = iter + 1;
    end
    indexScore(i,:) = min(dissim);
end
indexScore = min(indexScore);
end