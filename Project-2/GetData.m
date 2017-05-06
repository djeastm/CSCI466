function [ Data, Labels ] = GetData( type , reduce, randomize)
%GetData

data = strcat('data_',strcat(num2str(type),'.tif'));

D = imread(data);
D = D(:,:,1);

[C1x,C1y] = ind2sub(size(D),find(D==0));
[C2x,C2y] = ind2sub(size(D),find(D==255));

% Reduce number of pixels by constant factor
% (used when making datasets in paint)
reduceFactor = 50; % 32
if (reduce == true)
    C1x = C1x(1:reduceFactor:end,:);
    C1y = C1y(1:reduceFactor:end,:);
    C2x = C2x(1:reduceFactor:end,:);
    C2y = C2y(1:reduceFactor:end,:);
end

labelsC1 = -ones(size(C1x)); % black
labelsC2 = ones(size(C2x)); % white
C1 = [C1x C1y];
C2 = [C2x C2y];
Data = [C1;C2];
Labels = [labelsC1;labelsC2];

if randomize == true
    DataAndLabels = [Data Labels];
    DataAndLabels = DataAndLabels(randperm(size(DataAndLabels,1)),:);
    Data = DataAndLabels(:,1:end-1);
    Labels = DataAndLabels(:,end);
end

% Standardize to Normal 
for i=1:size(Data,2)
    newData(:,i) = (Data(:,i) - mean(Data(:,i)))/std(Data(:,i));
end
Data = newData;
end

