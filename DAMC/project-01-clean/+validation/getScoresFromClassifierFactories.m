function scores = getScoresFromClassifierFactories(data,classifierFactories,scoreFun)
%GETSCORESFROMCLASSIFIERFACTORIES Summary of this function goes here
%   Detailed explanation goes here
    n = length(classifierFactories);
    scores.train = zeros(n,1);
    scores.validation = zeros(n,1);
    for i=1:n
        clf = classifierFactories(i).clfFactory.createClassifier(data.train,classifierFactories(i).hyperParams);
        scores.validation(i) = scoreFun(clf.predict(data.test.data), data.test.labels);
        scores.train(i) = scoreFun(clf.predict(data.train.data), data.train.labels);
        scores.cost(i) = classifierFactories(i).hyperParams;
    end
end

