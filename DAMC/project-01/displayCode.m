%Guidesheet I-1: Data exploration
close all;
load('data/testSet.mat')
load('data/trainLabels.mat')
load('data/trainSet.mat')

import classifiers.*;
import gathering.*;
import score.*;
import misc.*;

[nbSamples,nbFeatures]=size(trainData);
hyp = "Fisher"

% Creating a list of classifiers with varying hyperparameters
if hyp=="Fisher"
    features=[1:49,50:10:190,200:100:nbFeatures];
    features=[1:29, 30:3:87,90:10:190,200:100:nbFeatures];
    classifiers = [];
    for nFeatures = features
        prepareDataFuncFunc = @(data,labels)misc.selectDataFeaturesFunc(data,labels,nFeatures);
        classifiers = [classifiers, classifierFactory(prepareDataFuncFunc,"discrimType","diaglinear","prior","uniform")];
    end
elseif hyp == "PCA"
    nbPCs=[1:29, 30:3:87,90:10:400];
    nbPCs=[1:19, 20:5:95,100:40:400];
    features = nbPCs;
    classifiers = [];
    for nbPC = nbPCs
        prepareDataFuncFunc = @(data,labels)misc.selectDataPCFunc(data,labels,nbPC);
        classifiers = [classifiers, classifierFactory(prepareDataFuncFunc, "discrimType","diaglinear","prior","uniform")];
    end
else
    nbPCs=[1:29, 30:10:400];
    features = nbPCs;
    classifiers = [];
    for nbPC = nbPCs
        nbPC
        prepareDataFuncFunc = @(data,labels)misc.selectDataPCRankfeatFunc(data,labels,nbPC);
        classifiers = [classifiers, classifierFactory(prepareDataFuncFunc, "discrimType","diaglinear","prior","uniform")];
    end
end
    
    
if true
    % Shows the test and train errors for each hyperparameter for each kfold and mean error
    kfold = 10
    [testError, trainError] = predictor.crossValidationFromHyperparameters(trainData,trainLabels,kfold,classifiers);
    features2D = ones(kfold, 1) * features;
    len = numel(features2D);
    figure()
    % Test errors
    scatter(reshape(features2D, len, 1), reshape(testError, len, 1), 3, [0 0.3 1], "filled")
    hold on 
    % Train errors
    scatter(reshape(features2D, len, 1), reshape(trainError, len, 1), 3, [1 0 0], "filled")
    hold on 
    % Mean test errors
    plot(features, mean(testError, 1), "Color", [0 0.3 1], "LineWidth", 2)
    hold on 
    %Mean train errors
    plot(features, mean(trainError, 1), "Color", [1 0 0], "LineWidth", 2)
    hold on
    % Score
    plot(features, mean(testError, 1) .* mean(testError, 1) ./ mean(trainError, 1), "Color", [0 1 0.3], "LineWidth", 2)
    hold on 
    ylim([0 0.7])
    legend("Test error Raw", "Train error raw", "Test error Mean", "Train error mean", "Score");
end
hyp

% Operates 10 nested crossvalidations in order to figure out if there is 
errorsAll = struct("trainError", [], "validationError", [], "testError", [], "indices", []);
for j = 1:0
    j
    [errors, indices] = predictor.nestedCrossValidation(trainData, trainLabels, 10, 5,classifiers);
%     figure("Name", "Nested crossvalidation " + j)
%     scatter(features(indices), errors.testError, 25, [1 0 0], "filled");
%     xlabel("best NbFeatures for outerFold");
%     ylabel("error of best nbFeatures");
% 
%     figure("Name", "Nested crossvalidation Errors" + j)
%     boxplot([errors.trainError.'; errors.validationError.'; errors.testError.'].', "labels", ["Train error", "Validation error", "Test error"])
%     xlabel("best NbFeatures for outerFold");
%     ylabel("error of best nbFeatures");
    
    errorsAll.trainError = [errorsAll.trainError, errors.trainError];
    errorsAll.testError = [errorsAll.testError, errors.testError];
    errorsAll.validationError = [errorsAll.validationError, errors.validationError];
    errorsAll.indices = [errorsAll.indices, indices];
end

errorsAll.indices = reshape(errorsAll.indices, numel(errorsAll.indices), 1);
errorsAll.testError = reshape(errorsAll.testError, numel(errorsAll.testError), 1);
errorsAll.validationError = reshape(errorsAll.validationError, numel(errorsAll.validationError), 1);
errorsAll.trainError = reshape(errorsAll.trainError, numel(errorsAll.trainError), 1);

figure("Name", "Nested crossvalidation SUMMARY")
scatter(features(errorsAll.indices), errorsAll.testError, 25, [1 0 0], "filled");
xlabel("best NbFeatures for outerFold");
ylabel("error of best nbFeatures");

figure("Name", "Nested crossvalidation boxplot SUMMARY")
boxplot([errorsAll.trainError.'; errorsAll.validationError.'; errorsAll.testError.'].', "labels", ["Train error", "Validation error", "Test error"])
xlabel("best NbFeatures for outerFold");
ylabel("error of best nbFeatures");

if (false)
nbClasses = 2;
[indiceCorrect, indiceWrong]=getClassIndices(trainLabels); % cf Fonctions Auxiliaires
weight=[0.3 0.5 0.6];
classes=[0 1];
colorClass=[1 0 0;  0 0.6 0];
timeAxis=(1:nbFeatures) / 1.;

% Contains the min, max, mean and median feature for each class
% featureModel(class, stat, feature) is the stat (min, max...) computed for
% specified class along specified feature.
featuresIndices = 1:20:2000;
featureModel = zeros(2, 4, length(featuresIndices));
kfolds = 10;
[orderedIndexes, orderedPower] = rankfeat(trainData, trainLabels, "fisher");
scoresMean = zeros(length(orderedIndexes), 2);
for nbFeaturesTested=1:length(orderedIndexes)/5
    nbFeaturesTested
    classificationCreator = classifierFactory("diaglinear", "uniform");
    [scoresTest, scoresTrain] = crossValidationFeatures(trainData, (1:nbFeaturesTested), trainLabels, kfolds, classificationCreator);
    scoresMean(nbFeaturesTested, 1) = mean(scoresTest);
    scoresMean(nbFeaturesTested, 2) = mean(scoresTrain);
end

figure()
plot(1:length(orderedIndexes), scoresMean(:, 1));
hold on
plot(1:length(orderedIndexes), scoresMean(:, 2));
hold on
legend("Test error", "Train error");

figure()
plts = zeros(nbClasses, 1);
legends = cell(nbClasses, 1);
for class = 1:nbClasses
    features = trainData(trainLabels==classes(class), featuresIndices);
    featureModel(class, 1, :) = min(features, [], 1);
    plot(featuresIndices, squeeze(quantile(features, [0.25 0.75], 1)), "Color", colorClass(class, :), "lineStyle", ":");
    hold on
    plts(class) = plot(featuresIndices, squeeze(median(features, 1)), "Color", colorClass(class, :), "lineStyle", "-", "lineWidth", 2);
    hold on
    legends(class) = {"Class " + squeeze(classes(class))};
end
legend(plts, legends{:});
xlabel("Feature");
ylabel("Value");

featuresIndices = 1:nbFeatures;
[h, pvals] = ttest2(trainData(trainLabels==0, featuresIndices), trainData(trainLabels==1, featuresIndices));
figure()
semilogy(featuresIndices, pvals);
hold on
semilogy(featuresIndices, gaussianFilter(pvals, 50, .1), "lineWidth", 1.5, "color", [1 0 0]);
legend("raw p-Value", "gaussian filtered p-Value", "Location", "SouthEast");
xlabel("Feature");
ylabel("p-Value");
title("p-Value for each feature");

figure()
kFold = 20;
discrimTypes=["linear", "diaglinear", "diagquadratic"];
priors=["uniform", "empirical"];
scores = zeros(kFold, length(discrimTypes) * length(priors));
i = 1;
labels = [];
for discrimType = discrimTypes
    for prior = priors
        labels = [labels, discrimType + " " + prior];
        classifierCreator = classifierFactory(discrimType, prior);
        scores(:, i) = crossValidation(trainData, trainLabels, kFold, classifierCreator);
        i = i + 1;
    end
end

boxplot(scores, "Labels", labels, 'LabelOrientation', 'inline');
xlabel("Calssification method");
ylabel("Class error");
end