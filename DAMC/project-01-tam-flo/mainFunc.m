clear all;
clc;
close all;

load('data/testSet.mat')
load('data/trainLabels.mat')
load('data/trainSet.mat')

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
% 
% figure()
% imshow(covScore)
% figure()
% imshow(covData)

%% crossValidationTotale

kfold = 10; 
weight = 0.5 ; 

[ErrorMinTrain, nbFeaturesModelTrain, typeClassifierTrain]= crossValidationTotale(kfold, trainLabels, trainData, weight)



