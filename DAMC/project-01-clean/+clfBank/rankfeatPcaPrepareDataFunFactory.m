function pcaPrepareDataFun = rankfeatPcaPrepareDataFunFactory(nbPCs,precomputedParams)
%PCASELECTION Summary of this function goes here
%   Detailed explanation goes here
    pcaPrepareDataFun = @(data)prepareData(data,nbPCs,precomputedParams.coeff);
end

function preparedData = prepareData(data,nbPCs,coeff)
    pcaProjection = data * coeff;
    preparedData = pcaProjection(:,  1:nbPCs);
end

