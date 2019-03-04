function pcaPrepareDataFun = pcaCorrPrepareDataFunFactory(nbPCs,precomputedParams)
%PCASELECTION Summary of this function goes here
%   Detailed explanation goes here
    pcaPrepareDataFun = @(data)prepareData(data,nbPCs,precomputedParams);
end

function preparedData = prepareData(data,nbPCs,precomputedParams)
    data = zscore(data);
    data = misc.correlateFull(data, precomputedParams.samples);
    normalizedData = zscore(data);
    pcaProjection = normalizedData * precomputedParams.coeff;
    preparedData = pcaProjection(:, 1:nbPCs);
end

