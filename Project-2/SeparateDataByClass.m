function [ classCellArray , indices] = SeparateDataByClass( samples, labels, isLabeled)
%SeparateDataByClass Returns a set of matrices each containing data corresponding
%to unique classes

if nargin < 3
    isLabeled = false;
end

classes = unique(labels,'rows');
numClasses = size(classes,1);
classCellArray = cell(numClasses,1);
indices = cell(numClasses,1);
for c = 1:numClasses
    if isLabeled == 1
        classCellArray{c} = [samples(labels==classes(c),:) labels(labels==classes(c),:)];
    else
        classCellArray{c} = samples(labels==classes(c),:);
    end
    indices{c} = find(labels==classes(c));
end
end

