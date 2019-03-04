function pcaPrepareDataFun = pcaPrepareDataFunFactory(nbPCs,precomputedParams)
%PCASELECTION Summary of this function goes here
%   Detailed explanation goes here
    pcaPrepareDataFun = @(data)prepareData(data,nbPCs,precomputedParams);
end

function preparedData = prepareData(data,nbPCs,precomputedParams)
    normalizedData = misc.normalize(data,precomputedParams.mu,precomputedParams.sigma);
    pcaProjection = normalizedData * precomputedParams.coeff;
    preparedData = pcaProjection(:, 1:nbPCs);
end

