function [s] = score(yPred,yEff)
%SCORE Summary of this function goes here
%   Detailed explanation goes here
    s = zeros(size(yPred, 2), 1);
    for i = 1:size(yPred, 2)
        s(i) = immse(yPred(:, i) ,yEff) ./ var(yEff);
    end
end

