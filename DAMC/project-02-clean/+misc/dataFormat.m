function [xT] = dataFormat(x, n, features)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    xT = ones(size(x, 1), n * length(features) + 1);
    for i = 1:n
        xT(:, ((i-1)*length(features) + 1):(i*length(features))) = x(:,features) .^ i;
    end
end

