function pcaPrepareDataFun = pcaRankfeatPrepareDataFunFactory(nbPCs,precomputedParams)
%PCASELECTION Summary of this function goes here
%   Detailed explanation goes here
    pcaPrepareDataFun = @(data)prepareData(data,nbPCs,precomputedParams,precomputedParams.orderedFeaturesIndices);
end

function preparedData = prepareData(data,nbPCs,precomputedParams,orderedFeatIndices)
    normalizedData = misc.normalize(data,precomputedParams.mu,precomputedParams.sigma);
    pcaProjection = normalizedData * precomputedParams.coeff;
    preparedData = pcaProjection(:, orderedFeatIndices(1:nbPCs));
end

