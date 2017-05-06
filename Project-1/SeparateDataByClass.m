function [ classMatrix , indices] = SeparateDataByClass( samples, labels, isLabeled)
%SeparateDataByClass Returns a set of matrices each containing data corresponding
%to unique classes

if nargin < 3
    isLabeled = false;
end

classes = unique(labels,'rows');
numClasses = size(classes,1);
for i = 1:numClasses
    numSamples = size(samples(labels==classes(i),:),1);
    if isLabeled == 1
        classMatrix(1:numSamples,:,i) = [samples(labels==classes(i),:) labels(labels==classes(i),:)];
    else
        classMatrix(1:numSamples,:,i) = samples(labels==classes(i),:);
    end
    indices(1:numSamples,:,i) = find(labels==classes(i));
end
end

