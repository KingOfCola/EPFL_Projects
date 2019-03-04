function reshapedData = correlateFull(data,samples)
    reshapedData = zeros(size(data,1), size(samples,1));
    for i=1:size(samples,1)
        reshapedData(:,i) = correlate(data, samples(i,:));
    end
end

function correlations = correlate(data, sample)
    correlations = zeros(size(data,1),1);
    for i=1:size(data,1)
        correlations(i) = conv(data(i,:), fliplr(sample),"valid");
    end
end
