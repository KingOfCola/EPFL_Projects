function pcaPrecomputedParams = pcaCorrPrecomputedHyperParamsFun(data)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    pcaPrecomputedParams.samples = zscore(data.data);
    [pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma] = misc.normalization(data.data);
    pcaPrecomputedParams.coeff = pca(misc.normalize(data.data,pcaPrecomputedParams.mu,pcaPrecomputedParams.sigma));
end

