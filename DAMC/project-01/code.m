clear all;
clc;
close all;


load('testSet (1).mat')
load('trainLabels.mat')
load('trainSet (1).mat')

[sample,feature]=size(trainData);

figure()
plot(trainData(1,:))

% figure()
% plotmatrix(trainData(:, 1:100:end))

figure()
classeCorrect=find(trainLabels==0);
classeWrong=find(trainLabels==1);
histogram(trainData(classeCorrect,2000))
hold on
histogram(trainData(classeWrong,2000))


figure()
subplot(2,2,1);
boxplot(trainData(classeCorrect,[1:100:700]),'Notch','on')
hold on
boxplot(trainData(classeWrong,[1:100:700]),'Notch','on')

subplot(2,2,2);
boxplot(trainData(classeWrong,[1:100:700]),'Notch','on')

subplot(2,2,3);
boxplot(trainData(classeCorrect,[1:100:700]))

subplot(2,2,4);
boxplot(trainData(classeWrong,[1:100:700]))

