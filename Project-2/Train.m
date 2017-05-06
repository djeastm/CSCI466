function [x, b, time] = Train( Data, Labels, kernelType, Cval )
%TRAIN 
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
    tic
    [x,~,~,~,~] = quadprog(H+eye(N)*0.0001,ff,[],[],Aeq,beq,zeros(1,N),Cval*ones(1,N),[]);
    time = toc;
    eps = .0001;
    supportVectors = find(x > eps);
    supportX = x(supportVectors); % quadprog results for supportVectors
    supportData = Data(supportVectors,:);
    supportLabels = Labels(supportVectors);
    supportLength = length(supportLabels);
    %Now, solve for b
    % Create a set of b's and average them
    Bset = [];
    for i=1:supportLength
        Bval = 0;
        for j=1:supportLength
            K=Kernel(kernelType, supportData, supportData,i,j);
            % apply kernel function
            Bval = Bval + ( supportX(j) * supportLabels(j) * K );
        end
        Bval = supportLabels(i) * Bval;
        Bval = (1 - Bval)/supportLabels(i);
        Bset = [ Bset Bval ]; % weight vector
    end
    b = mean(Bset); % take the mean of the weights and calculate sumval
end

