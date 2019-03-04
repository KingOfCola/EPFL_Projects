close all;
import score.*
import validation.*
import clfBank.*
import graph.*

load("data/testSet.mat");
load("data/trainSet.mat");
load("data/trainLabels.mat");

data = struct();
data.data = trainData;
data.labels = trainLabels;

pcs = [1:10:190, 200:50:500];
allGroceries = [];

methods = ["fisher", "corr", "infgain"];
discrimTypes = ["diagLinear","diagquadratic","pseudolinear","linear"];
methods = ["fisher"];
discrimTypes = ["diaglinear", "diagquadratic"];

for discrimType=discrimTypes
    % PCA
    clfGrocery = classifier.classifierGrocery(@clfBank.pcaPrepareDataFunFactory,@clfBank.pcaPrecomputedHyperParamsFun,{"DiscrimType",discrimType,"prior","uniform"});
    grocery.clfGrocery = clfGrocery;
    grocery.hyperParams = pcs;
    grocery.discrimType = discrimType;
    grocery.method = "pca";
    classifierGroceries = [grocery];
    allGroceries = [allGroceries, grocery];
    kfolds = 10;
    scoreFun = @score.classError;
%     bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
%     bestClassif.method = "pca" + " " + discrimType;
% 
%     bestClassif
%     graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for PCA")
    for method = ["fisher"]
        % Rankfeat
        clfGrocery = classifier.classifierGrocery(@clfBank.rankfeatPrepareDataFunFactory,clfBank.rankfeatPrecomputedHyperParamsFun(method),{"DiscrimType",discrimType,"prior","uniform"});
        grocery.clfGrocery = clfGrocery;
        grocery.hyperParams = pcs;
        
        grocery.discrimType = discrimType;
        grocery.method = method;
        classifierGroceries = [grocery];
        allGroceries = [allGroceries, grocery];
        kfolds = 10;
%         scoreFun = @score.classError;
%         bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
%         bestClassif.method = "rankfeat " + method + " " + discrimType;
% 
%         bestClassif
%         graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for Rankfeat " + method)

        % PCA then rankfeat
        clfGrocery = classifier.classifierGrocery(@clfBank.pcaRankfeatPrepareDataFunFactory,clfBank.pcaRankfeatPrecomputedHyperParamsFun(method),{"DiscrimType",discrimType,"prior","uniform"});
        grocery.clfGrocery = clfGrocery;
        grocery.hyperParams = pcs;
        grocery.discrimType = discrimType;
        grocery.method = "pca " + method;
        classifierGroceries = [grocery];
        allGroceries = [allGroceries, grocery];
%         kfolds = 10;
%         scoreFun = @score.classError;
%         bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
%         bestClassif.method = "pca + rankfeat " + method + " " + discrimType;
% 
%         bestClassif
%         graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for PCA then Rankfeat " + method)

        % Rankfeat then PCA
        clfGrocery = classifier.classifierGrocery(@clfBank.rankfeatPcaPrepareDataFunFactory,clfBank.rankfeatPcaPrecomputedHyperParamsFun(method),{"DiscrimType","diaglinear"});
        grocery.clfGrocery = clfGrocery;
        grocery.discrimType = discrimType;
        grocery.method = "rankfeat " + method + " + pca";;
        grocery.hyperParams = 1:50;
        classifierGroceries = [grocery];
        allGroceries = [allGroceries, grocery];
        kfolds = 10;
        scoreFun = @score.classError;
        bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
        bestClassif.method = "rankfeat " + method + " + pca";
    
%         bestClassif
%         x = 1:50;
%         graph.plotCrossValidation(bestClassif,x,"Crossvalidation for Rankfeat " + method + " then PCA")
    end
end
if true
    outerFolds = 10;
    innerFolds = 10;
    results = validation.nestedCrossValidation(data,allGroceries,outerFolds,innerFolds,@score.classError);
    allGroceriesRavel = [];
    for i = 1:length(allGroceries)
        allGroceriesRavel = [allGroceriesRavel; repmat(allGroceries(i), length(allGroceries(i).hyperParams), 1)];
    end
    drafting;
end
if false
    index = zeros(outerFolds,1);
    scores = zeros(outerFolds, 1);
    methods = repmat("", outerFolds,1);
    scoresTrain = zeros(outerFolds, innerFolds, length(allGroceriesRavel));
    scoresValidation = zeros(outerFolds, innerFolds, length(allGroceriesRavel));
    for i=1:outerFolds
        index(i) = results(i).Value.index;
        scores(i) = results(i).Value.score;
        scoresTrain(i, :, :) = results(i).Value.trainScores;
        scoresValidation(i, :, :) = results(i).Value.validationScores;
        %clfFactory = results(i).Value.factory.grocery.createClassifierFactory(dataTrain.train);
        hyperParams = results(i).Value.factory.hyperParams;
        methods(i) = allGroceriesRavel(index(i)).discrimType + " " + allGroceriesRavel(index(i)).method;
    end
    methodsSorted = sort(methods);
    method = methodsSorted(1);
    methodsUnique = [methodsSorted(1)];
    nbMethods = [1];
    j=1;
    for i=2:outerFolds
        if methodsSorted(i) == method
            nbMethods(j) = nbMethods(j) + 1;
        else
            nbMethods = [nbMethods, 1];
            method = methodsSorted(i);
            methodsUnique = [methodsUnique, method];
            j = j +1;
        end
    end
    figure()
    pie(nbMethods, methodsUnique)
    figure()
    boxplot(scoresValidation(index(1), :, :));
end
if false
    nbTests = 4000;
    scoresTest = zeros(nbTests,1);
    close 'all';
    scoreTest = 1;
    t = 1;
    sTMin = 1;
    for t = 1:nbTests
        t
        testLabels = [repmat(0,151,1);repmat(1,48,1)];
        clfs = [];
        cp = cvpartition(trainLabels, "kfold",10);
        dataAll = misc.splitData(data, cp, 1);
        cp2 = cvpartition(dataAll.train.labels, "kfold",3);
        dataTrain = misc.splitData(dataAll.train, cp2, 1);
        for i=1:10
            index(i) = results(i).Value.index;
            scores(i) = results(i).Value.score;
            clfFactory = results(i).Value.factory.grocery.createClassifierFactory(dataTrain.train);
            hyperParams = results(i).Value.factory.hyperParams;
            clf = clfFactory.createClassifier(dataTrain.train, hyperParams);
            predTest = clf.predict(testData);
            scoreTest = score.classError(clf.predict(dataTrain.test.data), dataTrain.test.labels);
            if scoreTest < 0.15
                scoreTest
                misc.labelToCSV(predTest,"test_1.csv", "results");
            end
            clfs = [clfs, clf];
        end
        index;
        scores;
        clf = classifier.allClassifier(dataTrain.test,clfs,{"discrimType","diaglinear","prior","uniform"});
        scoreTest = score.classError(clf.predict(dataAll.test.data), dataAll.test.labels)
        predictedTest = clf.predict(testData);
        score.classError(predictedTest, testLabels);
        if scoreTest < sTMin
            sTMin = scoreTest;
            misc.labelToCSV(predictedTest,"test_16.csv", "results");
        end
        scoresTest(t) = scoreTest;
    end
    figure()
    imshow([clf.prepareData(dataAll.train.data),repmat(clf.predict(dataAll.train.data), 1, 20)*0.8]);
    figure()
    imshow([clf.prepareData(dataAll.test.data),repmat(clf.predict(dataAll.test.data), 1, 20)*0.8]);
    figure()
    imshow([clf.prepareData(testData),repmat(clf.predict(testData), 1, 20)*0.8]);
    figure()
    histogram(scoresTest);
    misc.labelToCSV(predictedTest,"test_15.csv", "results");
end