function gaussian = gaussianNormalized(size,sigma)
%GAUSSIANNORMALIZED Summary of this function goes here
%   Detailed explanation goes here
    x = linspace(-1., 1., size);
    gaussianUnnormalized = exp(-x .^ 2 / (2 * sigma ^ 2));
    gaussian = gaussianUnnormalized / sum(gaussianUnnormalized);
end

