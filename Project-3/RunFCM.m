function [ v, U ] = RunFCM(data, numClusters, distMeasure, fuzzifier)
%RUNFCM 
maxIterations = 100;
TOL = 1e-5;	
results = zeros(maxIterations,1);
% Start with a random membership matrix
U = rand(numClusters, size(data,1));
divisor = repmat(sum(U),numClusters,1); 
U = U./divisor; % normalize
for i = 1:maxIterations
	fuzzifiedU = U.^fuzzifier;
    denominator = repmat(sum(fuzzifiedU,2),1,size(data,2));
    v = (fuzzifiedU*data)./denominator; 
    if strcmp(distMeasure,'gkdistance')
        for k=1:numClusters
            ufi=U(k,:)'.^fuzzifier;
            c1=data-repmat(v(k,:),size(data,1),1);
            c2=repmat(ufi,1,size(data,2)).*c1;
            c3=c2'*c1;
            c3=c3./sum(ufi);
            S=(det(c3)).^(1/2)*inv(c3);
            W{k}=S;
        end
        distances = GKdist(data, v, W)';
    else
        distances = distmeasure(v, data, distMeasure);
    end    
    results(i) = sum(sum(fuzzifiedU.*(distances.^2))); 
    distSum = (distances.^-1).^(2/(fuzzifier-1));
    repeatDistSums = repmat(sum(distSum),numClusters,1);
    U = distSum./repeatDistSums;
	if i > 1
        if abs(results(i) - results(i-1)) < TOL
            break; 
        end
	end
end	
end

