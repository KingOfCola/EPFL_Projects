function [prepareDataFunc] = selectDataPCRankfeatFunc(trainData,trainLabels,nbPCs)
%SELECTDATAFEATURESFUNC Summary of this function goes here
%   Detailed explanation goes here
    [coeff, ~, ~] = pca(trainData);
    [orderedIndex, ~] = misc.rankfeat(trainData * coeff, trainLabels, "fisher");
    prepareDataFunc = @(data)getFirstPCs(data, coeff, orderedIndex, nbPCs);
end

function preparedData = getFirstPCs(data, coeff, orderedIndex, nbPCs)
    pcs = (data * coeff);
    preparedData = pcs(:, orderedIndex(1:nbPCs));
end

