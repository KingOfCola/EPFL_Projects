function [bestClassifierFactoryIndex, errors] = getBestHyperparameters(trainData,trainLabels,kFold,classifierFactories)
%GETBESTHYPERPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    [validationError, trainError] = predictor.crossValidationFromHyperparameters(trainData,trainLabels,kFold,classifierFactories);
    ts = trainScore(validationError, trainError);
    [~, bestClassifierFactoryIndex] = min(ts);
    errors = struct("trainError", mean(trainError(:, bestClassifierFactoryIndex)), "validationError", mean(validationError(:, bestClassifierFactoryIndex)));
end

function ts = trainScore(testError, trainError) 
    testE = mean(testError, 1);
    trainE = mean(trainError, 1);
    ts = testE .* (testE ./ trainE);
end

