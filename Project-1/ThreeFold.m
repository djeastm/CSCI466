function [M,S, results, misclassRate, confusionMatrix ] = ...
ThreeFold( testsamples, testlabels, trainsamples, trainlabels)
%ThreeFold Perform one of the folds of three-fold cross validation

%% Train
[M,S] = Train(trainsamples,trainlabels);
%% Test 
results = Test(testsamples, M,S); % Results vector
misclassRate = CalculateError(results, testlabels);
confusionMatrix = confusionmat(results(1,:)',testlabels);
end

