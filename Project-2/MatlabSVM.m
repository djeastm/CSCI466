function [  ] = MatlabSVM( Data, Labels, kernelType)

kernel = 'polynomial';
switch (kernelType)
    case 'poly'
        kernel = 'polynomial';
    case 'rbf'
        kernel = 'rbf';
    case 'dot'
        kernel = 'linear';
    case 'tanh'
        kernel = 'tanhKernel';
end
SVMModel = fitcsvm(Data,Labels,'KernelFunction',kernel,'Standardize',true);
sv = SVMModel.SupportVectors;
PlotData(Data, Labels, sv);
end

