function [ Res ] = Test(supportData, supportLabels, supportX, testData, kernelType, weight)
%TEST Tests the new Data against the support vectors
    supportLength = length(supportLabels);
    N = size(testData,1);
    Res = zeros(1,N);
    for i=1:N
        sumVal = 0;
            for j=1:supportLength
                K=Kernel(kernelType, supportData, testData, i,j);
                sumVal = sumVal + supportX(j)*supportLabels(j)*K;
            end
        Res(i) = sumVal + weight; % the sum plus the weight vector
    end
    Res = Res';
end

