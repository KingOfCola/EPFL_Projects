clear all;
clc;
close all;
import misc.*;

%Guidesheet I-1: Data exploration

load('data/testSet.mat')
load('data/trainLabels.mat')
load('data/trainSet.mat')

[nbSamples,nbFeatures]=size(trainData);
[indiceCorrect, indiceWrong]=getClassesIndices(trainLabels); % cf Fonctions Auxiliaires
weight=[0.3 0.5 0.6];

%% Statistical signi?cance: 

%t-test approach to find key features in comparision class distribution

hypos = zeros(1, nbFeatures);
pvals = zeros(1, nbFeatures);
classCorrect = trainData(indiceCorrect, :);
classWrong = trainData(indiceWrong, :);
% 
% for feature = 1:nbFeatures
%     [h, weightValue] = ttest2(classCorrect(:, feature), classWrong(:, feature));
%     hypos(feature) = h;
%     pvals(feature) = weightValue;
% end
%  
% %Can you simply use the t-test for all of your features? If not, what exactly is the problem?
% %Normalement si ça marche avec le code suivant
% %[x, y] = ttest2(classCorrect(:,:), classWrong(:,:));
% 
% %In which range are the p-values you get with the t-test for ”good” and ”bad” features?
% %good (bad) feature are whose obtained for a maximum (minimum) p value
% [pValMin, featureMin] = min(pvals);
% [pValMax, featureMax] = max(pvals);
% 
% 
% %% examples of very similar and very di?erent distributions between classes.
% 
% %Histogram plot
% 
% %different distribution
% figure()
% histogram(trainData(indiceCorrect,featureMin),"FaceColor",'g')
% hold on
% histogram(trainData(indiceWrong, featureMin),"FaceColor",'r')
% legend('correct','wrong')
% xlabel('EEG record for Featuremin')
% ylabel('Proportion')
% title('Different class distribution comparison, histogram of FeatureMin(pvalue min)')
% 
% %similar distribution
% figure()
% histogram(trainData(indiceCorrect,featureMax),"FaceColor",'g')
% hold on
% histogram(trainData(indiceWrong, featureMax),"FaceColor",'r')
% legend('correct','wrong')
% xlabel('EEG record for Featuremax')
% ylabel('Proportion')
% title('Similar class distribution comparison, histogram of FeatureMax(pvalue max)')
% 
% % Box plot and Notch parameter
% %Create a boxplot of these features and compare it regarding the diferent classes.
% 
% interval=710:720;
% figure()
% boxplot(trainData(indiceCorrect,interval),'Notch','on')
% hold on
% boxplot(trainData(indiceWrong,interval),'Notch','on')
% title('Comparision of class distribution, using a boxplot of feature [710-720]')
% 
% %Repeat the boxplot you did before, but add the ”Notch” parameter. How does this change your view?
% %The box give a better distribution
% figure()
% subplot(2,2,1);
% boxplot(trainData(indiceCorrect,interval),'Notch','on')
% title('Boxplot of ClassCorrect on feature [710-720] with Notch parameter')
% subplot(2,2,2);
% boxplot(trainData(indiceWrong,interval),'Notch','on')
% title('Boxplot of ClassWrong on feature [710-720] with Notch parameter')
% subplot(2,2,3);
% boxplot(trainData(indiceCorrect,interval))
% title('Boxplot of ClassCorrect on feature [710-720] without Notch parameter')
% subplot(2,2,4);
% boxplot(trainData(indiceWrong,interval))
% title('Boxplot of ClassWrong on feature [710-720] without Notch parameter')
% 
% 
% %% Feature thresholding
% 
% % 1. How can the class histograms for a feature help you to optimally place the threshold?
% % Medium in the overlapping distribution
% 
% % 2. Plot the datapoints of two features (2D) and plot the optimal threshold for feature one as a line.
% plotscatter(classCorrect, classWrong, 10, 2000, weight(2))
% 
% %What are the particular shortcomings of feature thresholding?
% %not efficient in 2D, because needs an angle !
% 
% 
% %Plot class error and classi?cation error as functions of threshold values. 
% nbThresholds = 60;
% featuresCorrect = classCorrect(:, featureMin);
% featuresWrong = classWrong(:, featureMin);
% colors=["red" "green" "blue"];
% [classificationErrors, classErrors] = getErrors(featuresCorrect, featuresWrong, nbThresholds, weight);
% thresholds = (0:nbThresholds) * 1. / nbThresholds;
% figure()
% [weightInd, weightValue]=size(weight);
% for particularWeight=1:weightValue
% plot(thresholds, classErrors(:,particularWeight), "color", colors(particularWeight))
% hold on
% plot(thresholds, classificationErrors(:,particularWeight), "--", "color", colors(particularWeight))
% hold on
% legend("classErrors w="+weight(particularWeight),"classificationErrors w="+weight(particularWeight))
% end
% 
% %Describe what you see.
% % for low threshold, classification error is max because hugh chance to
% % misplace a sample from left in the wonrg right class
% %for hight thresholg, thus opposite mecanism. no chance to misplace a left
% %sample
% % classError, depends on weight, and reached a minimum => give the good
% % threshold
% 
% 
% %Change the ratio of 1/2 in the class error equation to 1/3 and 2/3. How does the threshold changes? Why?
% % The more you increase the weight, the more the "good" threshold moves to
% % the right. Indeed as the weight of your left class increased, you need to
% % displace the threhold to not place to much sample in this sample
% 
% 
% %What is the classi?cation error on your dataset? How di?erent is it from the class error?
% % classification error is the error of misplacing a sample according its
% % class. But be aware that if a class is very large => classification error
% % decreases.
% % class error is error according the difference of class proportion
% 
% % What is your ?nal model? At which accuracy do you expect your model to perform
% % we need to find the correct weight according to your experiment, and
% % measure the consequences it can involves (cost, danger..)
% 
% 
% %Can you scale this method up to multiple dimensions (e.g. using two features at once)?
% % we thing it is possible, but very difficult. 
% % 1.need to find the initiale position of the threshold line.( Angle?)
% % 2. then, need to place each sample in a class, according to the position
% % of its projection on the normal's plan of the initial threshold line.


%% LDA/QDA classi?ers

for discrimType = ["linear", "diagquadratic", "diaglinear"]
    for prior = ["uniform", "empirical"]
        datasetFeatures = trainData(:,1:10:end);
        classifier = fitcdiscr(datasetFeatures, trainLabels,'DiscrimType',discrimType,'Prior',prior);
        [predictClass] = predict(classifier, datasetFeatures); 
        correctWeight=0.5;
        [classificationError,classError] = errorsPrediction(predictClass, trainLabels,correctWeight);
        str = discrimType + " " + prior + " " + classificationError + " " + classError;
        str
    end
end

%% cross validation

rng(1);
weight = 0.5 ;
kfold = 10;
featuresNumbers = [1:200];
nbFeatures = length(featuresNumbers);
scoresTrain = zeros(kfold, nbFeatures);
scoresTest = zeros(kfold, nbFeatures);
abscisse = zeros(kfold, nbFeatures);
crossPartition = cvpartition(trainLabels, 'kfold', kfold);
EcartError = zeros(kfold, nbFeatures);


for i = 1:kfold
    for j=1:nbFeatures
    
    
        feature = featuresNumbers(j);
        trainK = crossPartition.training(i);
        IndTrainK = find(trainK == 1); 
        testK = crossPartition.test(i);
        IndTestK = find(testK == 1); 
        
        [orderedInd, orderedPower] = rankfeat(trainData(IndTrainK,:), trainLabels(IndTrainK,:), 'fisher');
        
        classifier = fitcdiscr(trainData(IndTrainK, orderedInd(1:feature)), trainLabels(IndTrainK),'discrimtype','diaglinear');
        predictedLabelsTest = predict(classifier, trainData(IndTestK,orderedInd(1:feature)));
        predictedLabelsTrain = predict(classifier, trainData(IndTrainK,orderedInd(1:feature)));
        [classificationErrorTest,classErrorTest] = errorsPrediction(predictedLabelsTest,trainLabels(IndTestK),weight);
        [classificationErrorTrain,classErrorTrain] = errorsPrediction(predictedLabelsTrain,trainLabels(IndTrainK),weight);
     
        EcartError(i,j) = abs(classErrorTrain - classErrorTrain); 
        
        scoresTrain(i, j) = classErrorTrain; 
        scoresTest(i, j) = classErrorTest; 
        abscisse(i,j) = feature ; 
        
  
    end
    
end

figure()
scatter(reshape(abscisse, [kfold * nbFeatures 1]), reshape(scoresTest, [kfold * nbFeatures 1]), 4);
hold on
scatter(mean(abscisse, 1), mean(scoresTest, 1), 4, 'b','LineWidth', 2);
hold on
scatter(reshape(abscisse, [kfold * nbFeatures 1]), reshape(scoresTrain, [kfold * nbFeatures 1]), 4);
hold on
scatter(mean(abscisse, 1), mean(scoresTrain, 1), 4,  'r','LineWidth', 2);

somme = 0;
moyenne = zeros(1,nbFeatures) ; 
for indFeatures = 1:nbFeatures
    for indKold = 1:kfold
         somme = somme + EcartError(indKold,indFeatures); 
    end
    moyenne(1,indFeatures) = somme./kfold ; 
end

minEcartError = 0; 
[nbfeaturesOptimal, minEcartError] = min(moyenne)

%%nested cross validation

nbOuters = 3; 
nbInners = 4; 

[IndOuterTrainKFolds, IndOuterTestKFolds] = crossValidationPartition(trainData, trainLabels, nbOuters);

for i = 1:nbOuters
    [IndInnerTrainKFolds, IndInnerTestKFolds] = crossValidationPartition(trainData(IndOuterTrainkFolds(:,i),:), trainLabels(IndOuterTrainKFolds(:,i)), nbInners);
end



%% training and testing error

set1Train=datasetFeatures(1:2:end,:);
set2Test=datasetFeatures(2:2:end,:);

for discrimType = ["linear", "diagquadratic", "diaglinear"]
        for prior = ["uniform", "empirical"]
            correctWeight=0.5;
            classifier = fitcdiscr(set1Train, trainLabels(1:2:end),'DiscrimType',discrimType,'Prior',prior);
    [predictClassTrain] = predict(classifier, set1Train); 
    [classificationErrorTrain, classErrorTrain] = errorsPrediction(predictClassTrain, trainLabels(1:2:end),correctWeight);

    [predictClassTest] = predict(classifier, set2Test); 
    [classificationErrorTest, classErrorTest] = errorsPrediction(predictClassTest, trainLabels(2:2:end),correctWeight);
            str = discrimType + prior + " classificationErrorTest:"  +  classificationErrorTest ...
                + " classificationErrorTrain:" +  classificationErrorTrain ...
                + " classErrorTest:"  +  classErrorTest ...
                + " classErrorTrain:"  +  classErrorTrain;
            str
        end
end

part=cvpartition(nbSamples,'kfold',10);
propN = zeros(10, 4);
for i=1:10
    propN(i, 1) = sum(trainLabels(part.training(i))==0);
    propN(i, 2) = sum(trainLabels(part.training(i))==1);
    propN(i, 3) = sum(trainLabels(part.test(i))==0);
    propN(i, 4) = sum(trainLabels(part.test(i))==1);
end
propN

part=cvpartition(trainLabels,'kfold',10);
propTrainDataSet = zeros(10, 2);
for i=1:10
    propTrainDataSet(i, 1) = sum(trainLabels(part.training(i))==0);
    propTrainDataSet(i, 2) = sum(trainLabels(part.training(i))==1);
    propTrainDataSet(i, 3) = sum(trainLabels(part.test(i))==0);
    propTrainDataSet(i, 4) = sum(trainLabels(part.test(i))==1);
end
propTrainDataSet
% en échangeant le setTrain et setTest
% for discrimType = ["linear", "diagquadratic", "diaglinear"]
%   
%         correctWeight=0.5;
%         classifier = fitcdiscr(set2Test, trainLabels(2:2:end),'DiscrimType',discrimType);
% [predictClassTrain] = predict(classifier, set2Test); 
% [classificationErrorTrain, classErrorTrain] = errorsPrediction(predictClassTrain, trainLabels(2:2:end),correctWeight);
% 
% [predictClassTest] = predict(classifier, set1Train); 
% [classificationErrorTest, classErrorTest] = errorsPrediction(predictClassTest, trainLabels(1:2:end),correctWeight);
%         str = "bis" +discrimType + " classificationErrorTest:"  +  classificationErrorTest ...
%             + " classificationErrorTrain:" +  classificationErrorTrain ...
%             + " classErrorTest:"  +  classErrorTest ...
%             + " classErrorTrain:"  +  classErrorTrain;
%         str
%   
% end

%% 

%% Fonctions auxiliaires

function [classesCorrect, classesWrong] = getClassesIndices(labels) 
    classesCorrect = find(labels==0);
    classesWrong = find(labels==1);
end

function [classificationError, classError] = errors(featuresCorrect, featuresWrong, threshold, correctWeight)
    [nbCorrect] = size(featuresCorrect);
    [nbWrong] = size(featuresWrong);
    [nbFalsePredictCorrect] = size(find(featuresCorrect >= threshold));
    [nbFalsePredictWrong] = size(find(featuresWrong < threshold));
    classificationError = (nbFalsePredictCorrect + nbFalsePredictWrong) / (nbCorrect + nbWrong);
    classError = (correctWeight) * nbFalsePredictCorrect / (1. * nbCorrect) + (1.-correctWeight) * nbFalsePredictWrong / nbWrong;
end

function [classificationError, classError] = errorsPrediction(predictClass, trainLabels,correctWeight)
nbCorrect=sum(trainLabels==1);
nbWrong=sum(trainLabels==0);
[nbSamples]=size(trainLabels);

nbFalsePredictWrong=0;
nbFalsePredictCorrect=0;
for sample=1:nbSamples
    if predictClass(sample)==1 && trainLabels(sample)==0
        nbFalsePredictWrong=nbFalsePredictWrong+1;
    elseif predictClass(sample)==0 && trainLabels(sample)==1
        nbFalsePredictCorrect=nbFalsePredictCorrect+1;
    end
end
classificationError = (nbFalsePredictCorrect + nbFalsePredictWrong) / (nbCorrect + nbWrong);
classError = (correctWeight) * nbFalsePredictCorrect / (1. * nbCorrect) + (1.-correctWeight) * nbFalsePredictWrong / nbWrong;
end 


function [classificationErrors, classErrors] = getErrors(featuresCorrect, featuresWrong, nbThresholds, correctWeights)
    [ligne,weightInd]=size(correctWeights);
    classificationErrors = zeros(nbThresholds+1,weightInd);
    classErrors = zeros(nbThresholds+1,weightInd);
    for particularWeight=1:weightInd
        for (i = 0:nbThresholds)
            threshold = i/nbThresholds;
            [classificationErrors(i+1,particularWeight), classErrors(i+1,particularWeight)] = errors(featuresCorrect, featuresWrong, threshold, correctWeights(particularWeight));
        end
    end
end


function [thresh]=getThreshold(trainCorrect, trainWrong, feature1, feature2,weight)
    nbThreshs = 60;
    threshs = (0:nbThreshs) *1./ nbThreshs;
    [classificationErrors, classErrors] = getErrors(trainCorrect(:, feature1), trainWrong(:, feature1), nbThreshs, weight);
    [classError, idThresh] = min(classErrors);
    thresh = threshs(idThresh);
end

function plotscatter(trainCorrect, trainWrong, feature1, feature2, weight)
    thresh = getThreshold(trainCorrect, trainWrong, feature1, feature2,weight);
    
    figure()
    scatter(trainCorrect(:, feature1), trainCorrect(:, feature2), 30, [0 0.8 0.2]);
    hold on
    scatter(trainWrong(:, feature1), trainWrong(:, feature2), 30, [1 0 0]);
    hold on
    plot([thresh(1), thresh(1)], [0, 1], 'r--', 'Color', [0 0 0]);
    xlabel("feature " + feature1);
    ylabel("feature " + feature2);
    title('Plot of two features and first threshold');
    legend("Correct", "Wrong");
end

function [IndTrainK, IndTestK] = crossValidationPartition(trainData, trainLabels, kfold)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
%   trainData: the set of data used for crossValidation
%   trainLabels: the labels of trainData
%   kfold: the kfold of the crossvalidation
%   predictorCreator: the creator of the predictor. Should be a function
%   taking trainData and trainLabels as parameters and returning a trained
%   predictor.
    rng(1);
    IndTrainKFolds = zeros(nbSamples,kfold);
    IndTestKFolds = zeros(nbSamples,kfold);
    
    scores = zeros(kfold, 1);
    crossPartition = cvpartition(trainLabels, 'kfold', kfold);
    for i = 1:kfold
        trainK = crossPartition.training(i);
        IndTrainKFolds(:,i) = find(trainK == 1); 
        testK = crossPartition.test(i);
        IndTestKFolds = find(testK == 1); 
       
    end
    
end

