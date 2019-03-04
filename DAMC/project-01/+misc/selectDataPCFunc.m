function [prepareDataFunc] = selectDataPCFunc(trainData,trainLabels,nbPCs)
%SELECTDATAFEATURESFUNC Summary of this function goes here
%   Detailed explanation goes here
    [coeff, ~, ~] = pca(trainData);
    prepareDataFunc = @(data)getFirstPCs(data, coeff, nbPCs);
end

function preparedData = getFirstPCs(data, coeff, nbPCs)
    pcs = (data * coeff);
    preparedData = pcs(:, 1:nbPCs);
end