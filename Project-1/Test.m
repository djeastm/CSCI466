function [ results ] = Test( samples, M, S)
%Test Returns classification results
numSamples = size(samples,1);
results = zeros(1,numSamples);
%% Compute loss for each sample
for x = 1:numSamples
    loss = R(samples(x,:),M,S); 
    [~, results(1,x)] = min(loss);
end
end

