function [ totalHypervolume ] = FHV(data,centers,U,q)
%FHV Compute the fuzzy hypervolume index
N = size(data,1);
numClusters = size(data,2);
hypervolume = zeros(numClusters,1);
for j=1:numClusters
    center = centers(j,:);
    weight=U(:,j).^q;
    c1=data-repmat(center,N,1);
    c2=repmat(weight,1,numClusters).*c1;
    c3=c2'*c1;
    hypervolume(j)=sqrt(det(c3./sum(weight)));
end
totalHypervolume = sum(hypervolume);
%Small values of totalHypervolume indicate the existence of compact
%clusters
end