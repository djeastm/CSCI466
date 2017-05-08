function [ kernel ] = Kernel(type, trainData, testData, i,j )
%KERNEL Returns chosen kernel function
kernel = [];
% trainDatai is x, testDataj is z
switch (type)
    case 'poly'
        kernel = (trainData(j,:)*testData(i,:)' + 1)^2;
    case 'rbf'
        s = 3;
        kernel = exp(-(norm(trainData(j,:)-testData(i,:))^2)/s^2);
    case 'tanh'
        B = 2;
        y = -1;
        kernel = tanh(B*trainData(j,:)*testData(i,:)'+y);
    case 'dot'
        kernel = trainData(j,:)*testData(i,:)';
end


end

