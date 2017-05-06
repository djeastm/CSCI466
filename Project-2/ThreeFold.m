function [supportVectors, results, misclassRate, confusionMatrix, time, misclassedSamples ] = ...
ThreeFold(trainData, trainLabels, testData, testLabels, kernelType, Cval)
%ThreeFold Perform one of the folds of three-fold cross validation

%% Train
[x, weight, time] = Train(trainData,trainLabels, kernelType, Cval);
eps = .0001;
supportVectors = find(x > eps);
supportX = x(supportVectors); % quadprog values of supportVectors
supportData = trainData(supportVectors,:);
supportLabels = trainLabels(supportVectors);
%% Test 
results = Test(supportData, supportLabels, supportX, testData, kernelType, weight); % Results vector
normalizedResults = sign(results);
%% Analyze Results
[misclassedLogical, misclassRate] = CalculateError(normalizedResults, testLabels);
misclassedSamples = testData(misclassedLogical,:);
confusionMatrix = confusionmat(normalizedResults,testLabels);
end
