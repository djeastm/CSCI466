function [ X ] = LoadDataSet( filename )
%LOADDATASET 
Img = imread(strcat(filename,'.PGM'));
[R, C] = find( Img == 0 );
X = [ R C ];
% Standardize to Normal 
for i=1:size(X,2)
    newData(:,i) = (X(:,i) - mean(X(:,i)))/std(X(:,i));
end
X = newData;
end

