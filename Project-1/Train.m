function [ M,S ] = Train( samples, labels )
%Train Returns the mean and covariance matrices of each class

%% Separate dataset into classes
classes = SeparateDataByClass(samples, labels);

numFeatures = size(classes,2);
numClasses = size(unique(labels),1);
%% Get means and covariances for each class
M = zeros(numFeatures,numClasses); % Mean Matrices
S = zeros(numFeatures,numFeatures,numClasses); % Covariance Matrices

for i = 1:numClasses
    M(:,i) = GetMeanOfFeatureVector(classes(:,:,i));
    S(:,:,i) = GetCovarianceMatrix(classes(:,:,i));
end

end

