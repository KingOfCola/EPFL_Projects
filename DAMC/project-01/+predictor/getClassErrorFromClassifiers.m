function [testError,trainError] = getClassErrorFromClassifiers(data,classifiers)
%GETCLASSERRORFROMCLASSIFIERS Summary of this function goes here
%   Detailed explanation goes here
%   data:   struct with fields trainData, trainLabels, testData, testLabels
%   classifiersFromHyperParameters: list of classifierFactories:
%       - Functions returning 
    nbClassifiers=length(classifiers);
    testError=zeros(1,nbClassifiers);
    trainError=zeros(1,nbClassifiers);
    for j=1:nbClassifiers
        classifierToTest = classifiers(j);
        classifier = classifierToTest.fit(data.trainData, data.trainLabels);
        testError(1, j)  = classifier.classError(data.testData, data.testLabels );
        trainError(1, j) = classifier.classError(data.trainData,data.trainLabels);
    end
end

