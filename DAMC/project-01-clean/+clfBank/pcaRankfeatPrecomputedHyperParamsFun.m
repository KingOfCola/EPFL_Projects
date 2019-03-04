function pcaPrecomputedParamsFun = pcaRankfeatPrecomputedHyperParamsFun(method)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    pcaPrecomputedParamsFun = @(data)pcaRankfeatPrecomputedHyperParamsFunAux(data,method);
end


function pcaPrecomputedParams = pcaRankfeatPrecomputedHyperParamsFunAux(data,method)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    [pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma] = misc.normalization(data.data);
    pcaPrecomputedParams.coeff = pca(misc.normalize(data.data,pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma));
    pcaPrecomputedParams.orderedFeaturesIndices = misc.rankfeat(data.data * pcaPrecomputedParams.coeff, data.labels, method);
end

