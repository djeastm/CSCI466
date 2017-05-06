function g = g( X, M, S, P )
%g Returns likelihood probability of a sample based on Gaussian distribution
g = -0.5*(X-M)'*inv(S)*(X-M)-(0.5*size(M,1))*log(2*pi)-0.5*log(det(S))+log(P);
end

