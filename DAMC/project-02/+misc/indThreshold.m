function index = indThreshold(x,p)
%INDTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    xCum = cumsum(x);
    th = xCum(length(xCum)) * p;
    index = sum(xCum < th);
end

