function [productedData] = product(data,features)
%PRODUCT Summary of this function goes here
%   Detailed explanation goes here
    nFeat = length(features);
    p = size(data, 2);
    productedData = zeros(size(data, 1), p + nFeat * (nFeat - 1) / 2);
    productedData(:, 1:p) = data;
    k = 0;
    for i=1:nFeat
        for j=(i+1):nFeat
            k = k+1;
            productedData(:, p+k) = data(:, features(i)) .* data(:, features(j));
        end
    end
end

