function [mu,sigma] = normalization(data)
%NORMALIZATION Summary of this function goes here
%   Detailed explanation goes here
    mu = mean(data,1);
    centeredData = data - mu;
    sigma = sqrt(var(centeredData,0,1));
end

