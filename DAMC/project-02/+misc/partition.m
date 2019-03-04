function [splittedData] = partition(data,pTrain, pValidation)
%PARTITION Summary of this function goes here
    %   Detailed explanation goes here
    [nbSamples] = size(data.data, 1);
    nbTrain = int32(nbSamples * pTrain);
    samples = 1:nbSamples;
    train = samples <= nbTrain;
    splittedOnceData = misc.splitData(data, train);
    
    samplesVal = 1:size(splittedOnceData.test.data, 1);
    nbVal = int32(nbSamples * pValidation);
    val = samplesVal <= nbVal;
    splittedTwiceData = misc.splitData(splittedOnceData.test, val);
    
    splittedData.train = splittedOnceData.train;
    splittedData.validation = splittedTwiceData.train;
    splittedData.test = splittedTwiceData.test;
end

