function [ covarianceMatrix ] = GetCovarianceMatrix( X )
%GetCovarianceMatrix Returns covariance matrix of given matrix
    %% Calculate deviations
    R = size(X,1);
    A = X - ones(R,1)*ones(1,R)*X.*(1/R);
    Aprime = A'*A;
    covarianceMatrix = Aprime./(R-1);
end

