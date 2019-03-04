function [splittedData] = partition(data,pTrain)
%PARTITION Summary of this function goes here
    %   Detailed explanation goes here
    [nbSamples] = size(data.data, 1);
    nbTrain = int32(nbSamples * pTrain);
    train = 1:nbTrain;
    test = (nbTrain+1):nbSamples;
    splittedData.train.data = data.data(train,:);
    splittedData.train.posX = data.posX(train);
    splittedData.train.posY = data.posY(train);
    
    splittedData.test.data = data.data(test,:);
    splittedData.test.posX = data.posX(test);
    splittedData.test.posY = data.posY(test);
end

