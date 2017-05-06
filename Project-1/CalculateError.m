function [errorRate] = CalculateError( results, labels )
%CalculateError Returns correct classifiation rate and the error rate
errorRate = sum(logical(labels - results'))/size(labels,1); 
end

