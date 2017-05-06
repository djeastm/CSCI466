function Data = GetTestData( dataName )

D = imread(dataName);
D = D(:,:,1);

[C1x, C1y] = ind2sub(size(D),find(D==0));
% [C2x,C2y] = ind2sub(size(D),find(D==255));
reduce = true;
% Reduce number of pixels by constant factor
% (used when making datasets in paint)
reduceFactor = 32; % 32
if (reduce == true)
    C1x = C1x(1:reduceFactor:end,:);
    C1y = C1y(1:reduceFactor:end,:);    
end
Data = [C1x C1y];
% Standardize to Normal 
for i=1:size(Data,2)
    newData(:,i) = (Data(:,i) - mean(Data(:,i)))/std(Data(:,i));
end
Data = newData;
 
%     plot(Data(:,1),Data(:,2),'xk');
end

