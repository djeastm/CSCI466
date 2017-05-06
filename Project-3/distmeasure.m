function distancemeasure = distmeasure(centroid, data, type)
%This function measures the distance for FCM and PCM algorithms

distancemeasure = zeros(size(centroid, 1), size(data, 1));
  
if size(centroid, 2) > 1,
    for k = 1:size(centroid, 1)
        switch type
            case 'euclidean'
            %Euclidean distance measure
            distancemeasure(k, :) = sqrt(sum(((data-ones(...
                size(data, 1), 1)*centroid(k, :)).^2)'));
            case 'manhattan'
            %Manhattan distance measure
            distancemeasure(k,:) = sum(abs((data-ones(...
                size(data, 1), 1)*centroid(k, :))'));
        end
    end
else	% 1-D data
    for k = 1:size(centroid, 1),
        distancemeasure(k, :) = abs(centroid(k)-data)';
    end
end 
end



