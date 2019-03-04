function pcaPrecomputedParamsFun = rankfeatPcaPrecomputedHyperParamsFun(method)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    pcaPrecomputedParamsFun = @(data)rankfeatPcaPrecomputedHyperParamsFunAux(data, method);
end



function pcaPrecomputedParams = rankfeatPcaPrecomputedHyperParamsFunAux(data, method)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    [pcaPrecomputedParams.orderedFeaturesIndices, pcaPrecomputedParams.orderedFeaturesPowers] = misc.rankfeat(data.data, data.labels, method);
    pcaPrecomputedParams.coeff = pca(data.data, "VariableWeights", pcaPrecomputedParams.orderedFeaturesPowers);
end

