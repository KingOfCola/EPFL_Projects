function correlations = correlate(data, n)
    correlations = zeros(size(data,1),size(data,2)-n+1);
    for j = 1:size(data,2)-n+1
        correlations(:,j) = max(data(:,j:j+n-1),[],2)- min(data(:,j:j+n-1),[],2);
    end
end
