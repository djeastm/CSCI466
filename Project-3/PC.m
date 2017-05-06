function [ indexScore ] = PC( data, U )
%PC Compute partition coefficient index
indexScore = sum(sum(U.^2))/size(data,1);
end
