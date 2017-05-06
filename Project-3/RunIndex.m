function [ score ] = RunIndex(type, data, centers, U, q)
%RunIndex 
score = [];
switch type
    case 'di'
        score = DUNN(data, centers, U);
    case 'pc'
        score = PC(data, U);
    case 'ce'
        score = ENTROPY(data, U);
    case 'fhv'
        score = FHV(data, centers, U, q);
    case 'cs'
        score = CS(data, centers, U);
    
end
end

