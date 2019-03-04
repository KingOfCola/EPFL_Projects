function [prepareDataFunc] = selectDataFeaturesFunc(trainData,trainLabels,nbFeatures)
%SELECTDATAFEATURESFUNC Summary of this function goes here
%   Detailed explanation goes here
    [orderedIndex, ~] = misc.rankfeat(trainData, trainLabels, "fisher");
    prepareDataFunc = @(data)data(:, orderedIndex(1:nbFeatures));
end

