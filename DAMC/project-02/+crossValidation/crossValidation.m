function [dataPartitionned] = crossValidation(data,pTrain,kFold)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    splittedData = misc.partition(data, pTrain);
    dataPartitionned.test = splittedData.test;
    trains = 1:(size(splittedData.train.data, 1));
    fold = floor((trains - 1) * kFold / len(trains)) + 1;
    dataPartitionned.partition = empty(struct, kFold, 0);
    
    for i = 1:kFold
        dp = misc.splitData(data, (fold ~= i));
        dataPartitionned.partition(i).train = dp.train;
        dataPartitionned.partition(i).validation = dp.test;
    end
end


