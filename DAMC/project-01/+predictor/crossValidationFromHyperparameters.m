function [testErrors,trainErrors] = crossValidationFromHyperparameters(trainData,trainLabels,kFold,classifierFactories)
%CROSSVALIDATIONFROMHYPERPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    cp=cvpartition(trainLabels,"kfold", kFold);
    trainErrors=zeros(kFold,length(classifierFactories));
    testErrors =zeros(kFold,length(classifierFactories));
    for i=1:kFold
        data = struct();
        data.trainData   = trainData  (cp.training(i), :);
        data.trainLabels = trainLabels(cp.training(i));
        data.testData    = trainData  (cp.test    (i), :);
        data.testLabels  = trainLabels(cp.test    (i));
        [testErrors(i,:), trainErrors(i,:)] = predictor.getClassErrorFromClassifiers(data,classifierFactories);
    end
end

