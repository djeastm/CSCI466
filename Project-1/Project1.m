clc; clear; close all;
%% Select Options
dataset = 'bezdek'; % 'bezdek' or 'gaussian'
method = 'resub'; % 'resub', '3fold', or 'kfold'
kfoldValue = 10; % default kfold value
%% Get data set with class label numbers in last column
[samples, labels] = GetData(dataset); 
%% Choose method to run
switch method
    case 'resub'
        %% Resubstitution
        % Train
        [M,S] = Train(samples, labels); % Means and Covariance matrices           
        % Test 
        results = Test(samples, M,S); % Results vector
        errorRate = CalculateError(results, labels);
        [confusionMatrix, order] = confusionmat(results(1,:)', labels);
    case '3fold'
        %% 3-Fold Cross Validation
        [classes indices] = SeparateDataByClass(samples, labels, true);
        numClasses = size(classes,3);
        folds = 3;
        %% Find amount to partition each class for each fold
        for c = 1:numClasses
            partitionAmount(c) = round(size(classes(:,:,c),1)/folds);
        end
        %% Run through each fold
        for f = 1:folds
            foldTesting =[];
            foldTestingLabels = [];
            foldTraining = [];
            foldTrainingLabels = [];
            idxTesting = [];
            %% Partition each class by taking the first third for testing
            % and rest for training
            for c = 1:numClasses
                class = classes(:,:,c);
                foldTesting = cat(1,foldTesting,class(1:partitionAmount(c),1:end-1));
                foldTestingLabels = cat(1,foldTestingLabels,class(1:partitionAmount(c),end)); 
                foldTraining = cat(1,foldTraining,class(partitionAmount+1:end,1:end-1));
                foldTrainingLabels = cat(1,foldTrainingLabels,class(partitionAmount+1:end,end));
                idxTesting = cat(1,idxTesting,indices(1:partitionAmount(c),:,c));
            end
            %% Run Train and Test
            [M(:,:,f),S(:,:,:,f), results(:,:,f), errorRate(:,f), confusionMatrix(:,:,f)] = ...
             ThreeFold(foldTesting, foldTestingLabels, foldTraining, foldTrainingLabels);
           
            %% Shift samples, labels and indicies circularly 
            % This makes sure that the next fold will be pulling from next partition
            for c = 1:numClasses
                classes(:,:,c) = circshift(classes(:,:,c),-partitionAmount(c));
                indices(:,:,c) = circshift(indices(:,:,c),-partitionAmount(c));
            end
        end
        %% Calculate average error rate over the 3 folds
        averageErrorRate = mean(errorRate);        
    case 'kfold' 
        %% k-fold Cross Validation
        % with randomization of samples
        folds = kfoldValue;
        CVO = cvpartition(labels,'k',folds);
        for f = 1:CVO.NumTestSets
            tr = CVO.training(f);
            te = CVO.test(f);
            % Train
            [M(:,:,f),S(:,:,:,f)] = Train(samples(tr,:),labels(tr,:));
            % Test 
            results(:,:,f) = Test(samples(te,:), M(:,:,f),S(:,:,:,f));
            errorRate(:,f) = CalculateError(results(:,:,f), labels(te,:));
            [confusionMatrix(:,:,f), order] = confusionmat(results(:,:,f)', labels(te,:));
        end
        %% Calculate average error rate over the 3 folds
        averageErrorRate = mean(errorRate);
        
end
        

