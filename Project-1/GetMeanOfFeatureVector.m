function [ featureMeanVector ] = GetMeanOfFeatureVector( vector )
%GetMeanOfFeatureVector Take the mean of a feature vector for a class
    [R,C] = size(vector);
    featureMeanVector = zeros(1,C);
    for i=1:C
        columnSum = 0;
        for j=1:R
            if vector(j,i) ~= 0
                columnSum = columnSum + vector(j,i);
            end
        end
        featureMeanVector(1,i) = columnSum / R;
    end
end

