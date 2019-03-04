function dataNormalized = normalize(data,mu,sigma)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
    dataNormalized = (data - mu) ./ sigma;
end

