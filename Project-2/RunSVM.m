function [ Data, Labels, SVs, misclassedSamples, errorRate, confusionMatrix,...
    timePerFold, numSVsPerFold] = ...
    RunSVM( dataset, method, kernelType, Cval, reduce, randomize )
%RunSVM Runs the SVM according to given options
%% Get data set with class label numbers in last column
[Data, Labels] = GetData(dataset, reduce, randomize); 
%% Choose method to run
numSVsPerFold = [];
timePerFold = [];
switch method
    case 'resub'
        %% Resubstitution
        %% Train
        [x, weight, time] = Train(Data,Labels, kernelType, Cval);
        eps = .0001;
        supportVectors = find(x > eps);
        supportX = x(supportVectors); % quadprog values of supportVectors
        supportData = Data(supportVectors,:);
        supportLabels = Labels(supportVectors);
        %% Test 
        results = Test(supportData, supportLabels, supportX, Data, ...
            kernelType, weight); % Results vector
        normalizedResults = sign(results);
        %% Analyze Results
        [misclassedLogical, errorRate] = CalculateError(normalizedResults, Labels);
        misclassedSamples = Data(misclassedLogical,:);
        confusionMatrix = confusionmat(normalizedResults,Labels); 
        SVs = supportData;
        numSVsPerFold = size(SVs,1);
        timePerFold = time;
    case '3fold'
        %% 3-Fold Cross Validation
        [classes, indices] = SeparateDataByClass(Data, Labels, true);
        numClasses = size(classes,1);
        folds = 3;
        %% Find amount to partition each class for each fold
        for c = 1:numClasses
            classSamples = classes(c);
            numSamples = size(cell2mat(classSamples),1);
            % Then calculate partition values
            partitionAmount(c) = floor(numSamples/folds);
        end
        % Set up 3-fold total results array
        % With one prefix col for indexing and
        % two final cols for actual labels and the tested classifications 
        finalResults = [];
        logicalSV = false(size(Data,1),1);
        %% Run through each fold
        for f = 1:folds
            foldTesting =[];
            foldTestingLabels = [];
            foldTraining = [];
            foldTrainingLabels = [];
            idxTesting = [];
            idxTraining = [];
            foldLogicalSV = false(size(Data,1),1);
            %% Partition each class by taking the first third for testing
            % and rest for training            
            for c = 1:numClasses  
                class = cell2mat(classes(c));
                index = cell2mat(indices(c));
                numSamples = size(class,1);
                if (f == folds && partitionAmount(c)*folds < numSamples)
                    diff = numSamples - partitionAmount(c)*folds;
                    partitionAmount(c) = partitionAmount(c) + diff;
                end
                idxTesting = cat(1,idxTesting,index(1:partitionAmount(c),:));
                foldTesting = cat(1,foldTesting,class(1:partitionAmount(c),1:end-1));
                foldTestingLabels = cat(1,foldTestingLabels,class(1:partitionAmount(c),end)); 
                
                idxTraining = cat(1,idxTraining,index(partitionAmount(c)+1:end,:));
                foldTraining = cat(1,foldTraining,class(partitionAmount(c)+1:end,1:end-1));
                foldTrainingLabels = cat(1,foldTrainingLabels,class(partitionAmount(c)+1:end,end));
                
            end
           
            %% Run Train and Test
            [supportVectors{f}, results{f}, errorRate(:,f), confusionMatrix(:,:,f), timePerFold(f), misclassedSamples{f}] = ...
            ThreeFold(foldTraining, foldTrainingLabels, foldTesting, foldTestingLabels, kernelType, Cval);
            numSVsPerFold(f) = size(cell2mat(supportVectors(f)),1);
            
            %% Log SupportVectors
            foldLogicalSV(idxTraining(cell2mat(supportVectors(f)))) = true;
            logicalSV = logicalSV | foldLogicalSV;
         
            %% Update final results array with this fold's data
            finalResults = [finalResults; idxTesting foldTesting ...
                            foldTestingLabels sign(cell2mat(results(f)))];
            
            %% Shift samples, labels and indices circularly 
            % This makes sure that the next fold will be pulling from next partition
            for c = 1:numClasses
                classes{c} = circshift(cell2mat(classes(c)),-partitionAmount(c));
                indices{c} = circshift(cell2mat(indices(c)),-partitionAmount(c));
            end
            
        end 
        
        %% Add support vector information for the folds
        finalResults = [finalResults logicalSV];
        
        %% Sort the results to combine the folds
        finalResults = sortrows(finalResults,1);
        
        %% Identify misclassed samples
        incorrect = finalResults(:,4) ~= finalResults(:,5);
        misclassedSamples = finalResults(incorrect,2:3);

        SVs = finalResults(finalResults(:,end) == true, 2:3);
end
end

