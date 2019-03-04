function pcaPrepareDataFun = rankfeatPrepareDataFunFactory(nbFeatures,orderedFeatures)
%PCASELECTION Summary of this function goes here
%   Detailed explanation goes here
    pcaPrepareDataFun = @(data)data(:,orderedFeatures(1:nbFeatures));
end
