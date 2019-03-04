clear all;
clc;
close all;

load('testSet.mat')
load('trainLabels.mat')
load('trainSet.mat')

%% featureSelection

% kfold = 10; 
% nbIt = 1 ; 
% nbFeatures = 10; 
% nbMaxSelectedFeatures = 100; 
% 
% IndMaxFeatures = 2000; 
% PasFeatures = 5; 
% abscisse = zeros(1,nbMaxSelectedFeatures);
% features = zeros(1,2048);
% 
% frequenceFeatures = FeaturesSelectionForward(trainData, trainLabels, kfold, nbIt);
%  
% features = [1:2048];
% figure()
% bar(features,frequenceFeatures);

%% PCA

% [score] = PCA(trainData);
% covScore = cov(score); 
% covData = cov(trainData);
% coeffPCA = pca(trainData); % On fait une PCA avec les données accessibles pour l'entraînement
% trainDataModified = trainData * coeffPCA;
% covScore = cov(trainDataModified);
% covData= cov(trainData);
% 
% figure()
% imshow(covScore)
% figure()
% imshow(covData)

%% crossValidationTotale

kfold = 10; 
weight = 0.5 ; 
PasFeatures=1;

[orderedFeatures,ErrorMinTest, nbFeaturesModelTest, typeClassifierTest]= crossValidationTotale(PasFeatures,kfold, trainLabels, trainData(:,[1:PasFeatures:2000]), weight)

%% Nested CV

% nbInners = 10; 
% nbOuters = 6;
% 
% weight = 0.5 ; 
% [NestedCVErrorTestOuters,nbFeaturesOptOuters, typeClassifierOpt]= NestedCV(nbOuters,nbInners, trainLabels, trainData(:,[1:10:200]), weight)



