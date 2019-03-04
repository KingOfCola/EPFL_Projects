function pcaPrecomputedParamsFun = rankfeatPrecomputedHyperParamsFun(method)
%PRECOMPUTEDHYPERPARAMSFUN Summary of this function goes here
%   Detailed explanation goes here
    pcaPrecomputedParamsFun = @(data)misc.rankfeat(data.data, data.labels,method);
end

