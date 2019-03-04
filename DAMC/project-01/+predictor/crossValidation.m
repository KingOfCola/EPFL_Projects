function [scoresTest, scoresTraining] = crossValidation(trainData, trainLabels, kfold, classifierCreator)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
%   trainData: the set of data used for crossValidation
%   trainLabels: the labels of trainData
%   kfold: the kfold of the crossvalidation
%   predictorCreator: the creator of the predictor. Should be a function
%   taking trainData and trainLabels as parameters and returning a trained
%   predictor.
    scoresTest = zeros(kfold, 1);
    scoresTraining = zeros(kfold, 1);
    size(trainData)
    crossPartition = cvpartition(trainLabels, 'kfold', kfold);
    for i = 1:kfold
        trainK = find(crossPartition.training(i)==1);
        testK = find(crossPartition.test(i)==1);
        classifier = classifierCreator(trainData(trainK, :), trainLabels(trainK));
        predictedLabels = classifier.predict(trainData(testK, :));
        scoresTest(i, 1) = score.getClassError(predictedLabels, trainLabels(testK), 0.5);
        predictedLabels = classifier.predict(trainData(trainK, :));
        scoresTraining(i, 1) = score.getClassError(predictedLabels, trainLabels(trainK), 0.5);
    end
end

