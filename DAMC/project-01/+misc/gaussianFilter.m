function [filteredSignal] = gaussianFilter(signal,size,sigma)
%GAUSSIANFILTER Summary of this function goes here
%   Detailed explanation goes here
%   https://stackoverflow.com/questions/6992213/gaussian-filter-on-a-vector-in-matlab
    filteredSignal=conv(signal, misc.gaussianNormalized(size, sigma), "same");
end

