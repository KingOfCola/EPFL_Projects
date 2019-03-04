function bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun)
%GETBESTCLASSIFIERGROCERY Summary of this function goes here
%   Detailed explanation goes here
    factories = generateFactoriesFromGroceries(data,classifierGroceries);
    scoresStruct = validation.crossValidation(data,kfolds,generateScoreCallback(factories,scoreFun));
    bestClassif = getMinScore(scoresStruct);
    bestClassif.factory = factories(bestClassif.index);
end

function factories = generateFactoriesFromGrocery(data,clfGrocery, factoryParams)
    factories = struct.empty(length(factoryParams), 0);
    factory = clfGrocery.createClassifierFactory(data);
    for i=1:length(factoryParams)
        factories(i).clfFactory=factory;
        factories(i).hyperParams = factoryParams(i);
        factories(i).grocery = clfGrocery;
    end
end

function factories = generateFactoriesFromGroceries(data,clfGroceries)
    factories = [];
    for i=1:length(clfGroceries)
        factories = [factories, generateFactoriesFromGrocery(data, clfGroceries(i).clfGrocery, clfGroceries(i).hyperParams)];
    end
end

function scoreCallback = generateScoreCallback(factories,scoreFun)
    scoreCallback = @(d)validation.getScoresFromClassifierFactories(d,factories,scoreFun);
end

function minScore = getMinScore(scoreStruct)
    minScore.trainScores = zeros(length(scoreStruct), length(scoreStruct(1).Value.train));
    minScore.validationScores = zeros(length(scoreStruct), length(scoreStruct(1).Value.validation));
    minScore.cost = zeros(length(scoreStruct), length(scoreStruct(1).Value.validation));
    for fold=1:length(scoreStruct)
        minScore.trainScores(fold,:) = scoreStruct(fold).Value.train;
        minScore.validationScores(fold,:) = scoreStruct(fold).Value.validation;
        minScore.cost(fold,:) = scoreStruct(fold).Value.cost;
    end
    minScore = scoreError(minScore);
    [minScore.score, minScore.index] = min(mean(minScore.scores,1));
end

function scores = scoreError(scores)
    scores.scores = scores.validationScores .* (1. + scores.cost ./ 400.);
end