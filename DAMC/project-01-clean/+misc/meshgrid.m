function [xList,yList] = meshgrid(xArr,yArr)
%MESHGRID Summary of this function goes here
%   Detailed explanation goes here
    nbElems = numel(yArr);
    xList = reshape(repmat(xArr, nbElems / length(xArr), 1), nbElems, 1);
    yList = reshape(yArr, nbElems, 1);
end

