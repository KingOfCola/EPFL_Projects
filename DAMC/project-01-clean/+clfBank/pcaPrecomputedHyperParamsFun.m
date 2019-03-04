function pcaPrecomputedParams = pcaPrecomputedHyperParamsFun(data)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    [pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma] = misc.normalization(data.data);
    pcaPrecomputedParams.coeff = pca(misc.normalize(data.data,pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma));
end

