function [errors, indices] = nestedCrossValidation(data,labels,outerKFold,innerKFold,classifierFactories)
%NESTEDCROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    outerCP = cvpartition(labels, "kfold", outerKFold);
    validationError = zeros(outerKFold, 1);
    trainError = zeros(outerKFold, 1);
    testError = zeros(outerKFold, 1);
    indices = zeros(outerKFold, 1);
    for i=1:outerKFold
        [indices(i), errors] = predictor.getBestHyperparameters(data(outerCP.training(i), :), labels(outerCP.training(i)), innerKFold, classifierFactories);
        classifierFactory = classifierFactories(indices(i));
        classifier = classifierFactory.fit(data(outerCP.training(i), :), labels(outerCP.training(i)));
        testError(i) = classifier.classError(data(outerCP.test(i), :), labels(outerCP.test(i)));
        trainError(i) = errors.trainError;
        validationError(i) = errors.validationError;
        i
    end
    errors = struct("trainError", trainError, "testError", testError, "validationError", validationError);
end

