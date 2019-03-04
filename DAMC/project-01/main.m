clear all;
clc;
close all;

%Guidesheet I-1: Data exploration

load('data/testSet.mat')
load('data/trainLabels.mat')
load('data/trainSet.mat')
colors = [1 0.6 0.6; 0.6 1 0.6];
dataColors = reshape(colors(trainLabels + 1, :), 597, 1, 3);
if true
    figure("Name", "Data")
    imshow(dataColors .* trainData)
    [coeff, score, variance] = pca(trainData);
    size(coeff)
    trainData2 = trainData * coeff;
    %variance = var(trainData2);

    figure("Name", "PCA covariance")
    imshow(cov(trainData2))
    figure("Nam", "Cumulated variance")
    plot(1:length(variance), cumsum(variance)/sum(variance))
    figure("Name", "PCA")
    imshow(normalize(coeff))
    figure("Name", "Score")
    imshow(score)
    figure("Name", "Normalized covariance matrix for raw data")
    imshow(normalize(cov(trainData)))
    figure("Name", "Projected Data on PCA")
    imshow(trainData2)
end

if false
cp = cvpartition(trainLabels, "kfold", 10);
[sel,hst] = sequentialfs(@getError,trainData,trainLabels,'cv',10)
end

function [normalizedMat] =  normalize(mat) 
    m = min(mat, [], "all")
    M = max(mat, [], "all")
    normalizedMat = (mat - m) ./ (M - m);
end

function error = getError(trainData, trainLabels, testData, testLabels)
    classifier = fitcdiscr(trainData, trainLabels, "discrimType", "diaglinear");
    error = length(trainLabels) * score.getClassError(predict(classifier, testData), testLabels, 0.5); 
end

