function D = GKdist(X, Y, A)
% X is data (ndata, ndim)
% Y is cluster centroids (nclust, ndim)
% A is distance norm matrix cell array (nclust, ndim, ndim)
[mx, nx] = size(X);
[my, ny] = size(Y);

D = zeros(mx, my);

for j = 1 : my
    W=A{j};
    Yj = Y(j,:);
    Yj = Yj(ones(mx,1),:);
    Dc = X - Yj;
    D(:,j) = real(sum((Dc * W) .* conj(Dc), 2));
end