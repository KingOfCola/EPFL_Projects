function [xT, mu,sigma] = normalize(x, varargin)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
    if length(varargin) < 2
        mu = mean(x, 1);
        sigma = std(x, 1, 1);
    else
        mu = varargin{1};
        sigma = varargin{2};
    end
    xT = (x - mu) ./ sigma;
end

