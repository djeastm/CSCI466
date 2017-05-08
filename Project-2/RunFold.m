function [ supportData, Res ] = RunFold( Data, Labels, kernelType, Cval )
%RUNFOLD Run each fold through training and testing
[N,~] = size(Data);
    H = zeros(length(Data));
    len = length(Data);
    for i=1:len
        for j=1:len
            K=Kernel(kernelType, Data, Data,i,j); % degree2 polynomial
            
            % Kernel - Move from high to low dimensional space and back
            % Hessian
            H(i,j) = Labels(i)*Labels(j)*K;
            % grabs labels and transfers them from high to low
        end
    end
    ff = -ones(N,1); % changes it to maximization problem
    Aeq = zeros(N,N);
    Aeq(1,:) = Labels;
    beq = zeros(N,1);
    eps = .0001;
    %eps = Cval*(1/100000); % parameter to deal with nonlinearly separable two class problems
    % 18 times run, total (for 3 folds x 3 c values x 2 diff kernels)
    % if you make C high , it will bias towards one class, so it should be small
    % but small C should put the hyperplane in the middle of the margin
    options = optimoptions(@quadprog,'MaxIterations',1000);
    tic
    [x,~,~,~,~] = quadprog(H+eye(N)*0.0001,ff,[],[],Aeq,beq,zeros(1,N),Cval*ones(1,N),[],options);
    toc
    supportVectors = find(x > eps);
    % eps very small value, so we ignore those 
    % eps = .0001 was suggested by Sam
    supportX = x(supportVectors);
    supportData = Data(supportVectors,:);
    supportLabels = Labels(supportVectors);
    supportLength = length(supportLabels);
    % Now, solve for b
    % b is the weight vector, w or omega, the initial weight
    % uses the support vector data, uses the kernel to transform them from low to high
    % dimension
    % C and the weights determine the direction of the hyperplane
    % Create a set of b's and average them
    Bset = [];
    for i=1:supportLength
        Bval = 0;
        for j=1:supportLength
            K=Kernel(kernelType, supportData, supportData,i,j);
            % apply kernel function
            Bval = Bval + ( supportX(j) * supportLabels(j) * K );
            % hessian matrix for the weights
        end
        Bval = supportLabels(i) * Bval;
        Bval = (1 - Bval)/supportLabels(i);
        Bset = [ Bset Bval ]; % weight vector
    end
    b = mean(Bset); % take the mean of the weights and use it to calculate sumval
    % need to compare all the data to the support vectors
    Res = zeros(1,N);
    for i=1:N
        sumVal = 0;
            for j=1:supportLength
                K=Kernel(kernelType, supportData, Data, i,j);
                sumVal = sumVal + supportX(j)*supportLabels(j)*K;
                % the correct classification for the data
            end
        Res(i) = sumVal + b; % the sum plus the mean of the weight vector
        % add the weight to get the right result
    end
    % Res = [ 1.0000 3.2755 3.0878 -1.0000 -1.0000 -3.2722 ]
    % these are the classifications of the points, positive 
    % Want the best result

end

