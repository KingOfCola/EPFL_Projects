function [classifierCreator] = classifierFactory(discrimType,prior)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    classifierCreator = @(trainingData, trainingLabels) fitcdiscr(trainingData, trainingLabels,'DiscrimType',discrimType,'Prior',prior);
end

