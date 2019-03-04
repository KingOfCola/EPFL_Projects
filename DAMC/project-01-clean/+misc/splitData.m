function splittedData = splitData(data,cp,fold)
%SPLITDATA Summary of this function goes here
%   Detailed explanation goes here
    splittedData.train.data = data.data(cp.training(fold), :);
    splittedData.train.labels = data.labels(cp.training(fold));
    splittedData.test.data = data.data(cp.test(fold), :);
    splittedData.test.labels = data.labels(cp.test(fold));
end

