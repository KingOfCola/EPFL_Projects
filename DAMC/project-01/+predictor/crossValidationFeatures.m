function [scoresTest, scoresTraining] = crossValidationFeatures(trainData, features, trainLabels, kfold, classifierCreator)
%CROSSVALIDATIONFEATURES Summary of this function goes here
%   Detailed explanation goes here
    trainDataFeatured = trainData(:, features);
    [scoresTest, scoresTraining] = predictor.crossValidation(trainDataFeatured, trainLabels, kfold, classifierCreator);
end

