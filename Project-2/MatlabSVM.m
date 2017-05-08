function [  ] = MatlabSVM( Data, Labels, kernelType)
% Helper function to run Matlab's built-in SVM functions to test
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

