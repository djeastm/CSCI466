function [ indexScore ] = ENTROPY( data, U )
%ENTROPY Compute partition entropy coefficient
indexScore = -sum(sum(U.*(log2(U))))/size(data,1);
end

