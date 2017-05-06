function R = R( sample, M, S )
%R Returns the risk vector for a sample for each class (to be minimized)
numClasses = size(M,2);
R = zeros(numClasses,1);
zeroone = ones(numClasses)-eye(numClasses);
%% Calculate priors
p = 1/numClasses;
P = ones(1,numClasses).*p;

%% Calculate risk
for i = 1:numClasses % r(i) for each class
    risk = 0;    
    %% Calculate P(w(j)|x) for each class and multiply by lambda
    for j = 1:numClasses
        %% P(w(j)|x) = g(x)
        likelihood = g(sample',M(:,j),S(:,:,j),P(j));
        %% Multiply by zero-one loss lambda and add to cumulative sum
        risk = risk + zeroone(i,j)*likelihood;         
    end
    R(i) = risk;    
end

end

