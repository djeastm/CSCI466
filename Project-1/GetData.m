function [samples, labels] = GetData( dataset )
%GetData Returns the data set in two matrices of samples and labels

switch dataset
    case 'bezdek'
        data = ReadFile('bezdekIris.data');
    case 'gaussian'
        data = ReadFile('Two_Class_FourDGaussians.dat');
    otherwise
        error('I do not know how to open anything other than bezdek or gaussian files!');
end
[R,C] = size(data);
labels = data(:,C);
samples = data(:,1:C-1);


end

