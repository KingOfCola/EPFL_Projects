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

pcs = [1:39, 40:5:90, 100:10:290, 300:50:500];
allGroceries = [];

method="fisher";
discrimType="diaglinear";


% data.data = misc.varWindow(data.data,20);
% data.data = data.data ./ max(data.data, [], 2);


% clfGrocery = classifier.classifierGrocery(@clfBank.pcaPrepareDataFunFactory,@clfBank.pcaPrecomputedHyperParamsFun,{"DiscrimType",discrimType,"prior","uniform"});
% grocery.clfGrocery = clfGrocery;
% grocery.hyperParams = pcs;
% classifierGroceries = [grocery];
% allGroceries = [allGroceries, grocery];
% kfolds = 10;
% scoreFun = @score.classError;
% bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
% bestClassif.method = "pca" + " " + discrimType;
% 
% bestClassif
% graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for PCA")

% clfGrocery = classifier.classifierGrocery(@clfBank.pcaRankfeatPrepareDataFunFactory,clfBank.pcaRankfeatPrecomputedHyperParamsFun(method),{"DiscrimType",discrimType,"prior","uniform"});
% grocery.clfGrocery = clfGrocery;
% grocery.hyperParams = pcs;
% classifierGroceries = [grocery];
% allGroceries = [allGroceries, grocery];
% kfolds = 10;
% scoreFun = @score.classError;
% bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
% bestClassif.method = "pca" + " " + discrimType;
% 
% bestClassif
% graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for PCA then Rankfeat")

% clfGrocery = classifier.classifierGrocery(@clfBank.rankfeatPrepareDataFunFactory,clfBank.rankfeatPrecomputedHyperParamsFun(method),{"DiscrimType",discrimType,"prior","uniform"});
% grocery.clfGrocery = clfGrocery;
% grocery.hyperParams = pcs;
% classifierGroceries = [grocery];
% allGroceries = [allGroceries, grocery];
% kfolds = 10;
% scoreFun = @score.classError;
% bestClassif = getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
% bestClassif.method = "rankfeat" + method + " " + discrimType;
% 
% bestClassif
% graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for Rankfeat")

[orderedIndex, orderedPower] = misc.rankfeat(data.data, data.labels, "ttest");
[h, p] = ttest2(data.data(data.labels==0,:),data.data(data.labels==1,:));
p = orderedPower(invert(orderedIndex));
p = (p - min(p)) / (max(p) - min(p));
pvals = repmat(p, 100,1);
colors = [1 0.6 0.6; 0.6 1 0.6;1 1 1];
tL = [trainLabels; repmat([2], 100, 1)];
dataColors = reshape(colors(tL + 1, :), length(tL), 1, 3);
dataIm = [data.data; pvals];
figure()
imshow(dataIm .* dataColors);

figure()
scatter(orderedIndex, log(orderedPower)-min(log(orderedPower)),10,"filled")
hold on
scatter(1:size(data.data,2), -log(p),10,"filled")

f1 = 178;
f2 = 1719;
figure()
scatter(data.data(data.labels==0,f1), data.data(data.labels==0,f2), 10,[1 0 0], "filled")
hold on
scatter(data.data(data.labels==1,f1), data.data(data.labels==1,f2), 10,[0 0.7 0], "filled")

figure()
plot(1:size(data.data,2), log(orderedPower))

figure()
data.data = zscore(data.data);
plot(1:size(data.data,1),correlate(data.data, data.data(100, :)))


data.data = [trainData;testData];
data.labels = [trainLabels;repmat(2,size(testData,1),1)];
% dataTestVar = misc.varWindow(testData,20);
% dataTestCorr = correlateFull(testData, data.data(:, :));
% data.data = zscore(correlateFull(data.data, data.data(:, :)));
[orderedIndex, orderedPower] = misc.rankfeat(trainData, trainLabels, "ttest");
[h, p] = ttest2(trainData(trainLabels==0,:),trainData(trainLabels==1,:));
p = orderedPower(invert(orderedIndex));
p = (p - min(p)) / (max(p) - min(p));
pvals = repmat(p, 100,1);
colors = [1 0.6 0.6; 0.6 1 0.6;1 1 1];
tL = [data.labels; repmat([2], 100, 1)];
dataColors = reshape(colors(tL + 1, :), length(tL), 1, 3);
dataIm = [data.data; pvals];
figure()
imshow(dataIm .* dataColors);

data.data = zscore(data.data);
dataTestCorr = zscore(dataTestCorr);

data.data = misc.varWindow(trainData,20);
data.labels = trainLabels;
pcs = [1:39, 40:5:90, 100:10:250];
clfGrocery = classifier.classifierGrocery(@clfBank.pcaRankfeatPrepareDataFunFactory,clfBank.pcaRankfeatPrecomputedHyperParamsFun(method),{"DiscrimType",discrimType,"prior","uniform"});
grocery.clfGrocery = clfGrocery;
grocery.hyperParams = pcs;
classifierGroceries = [grocery];
allGroceries = [allGroceries, grocery];
kfolds = 10;
scoreFun = @score.classError;
bestClassif = validation.getBestClassifierGrocery(data,classifierGroceries,kfolds,scoreFun);
bestClassif.method = "pca rankfeat" + " " + discrimType;

bestClassif
graph.plotCrossValidation(bestClassif,pcs,"Crossvalidation for PCA then Rankfeat")

clfFactory = bestClassif.factory.grocery.createClassifierFactory(data);
hyperParams = bestClassif.factory.hyperParams;
clf = clfFactory.createClassifier(data, hyperParams);
predictedTest = clf.predict(misc.varWindow(testData,20));
misc.labelToCSV(predictedTest,"test_05.csv", "results");

function y = invert(x)
    y = zeros(length(x), 1);
    for i=1:length(x)
        y(x(i)) = i;
    end
end

function correlations = correlate(data, sample)
    correlations = zeros(size(data,1),1);
    for i=1:size(data,1)
        correlations(i) = conv(data(i,:), fliplr(sample),"valid");
    end
end

function reshapedData = correlateFull(data,samples)
    reshapedData = zeros(size(data,1), size(samples,1));
    for i=1:size(samples,1)
        reshapedData(:,i) = correlate(data, samples(i,:));
    end
end