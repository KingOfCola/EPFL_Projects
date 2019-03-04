function results = crossValidation(data,kfolds,callback)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    results=struct.empty(kfolds, 0);
    cp = cvpartition(data.labels, "kfold",kfolds);
    for fold = 1:kfolds
        fold
        subdata=misc.splitData(data,cp,fold);
        results(fold).Value = callback(subdata);
    end
end

