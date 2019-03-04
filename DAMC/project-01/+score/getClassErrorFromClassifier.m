function error = getClassErrorFromClassifier(data,labels,classifier,prepareDataFunc)
%GETCLASSERRORFROMCLASSIFIER Summary of this function goes here
%   Detailed explanation goes here
    preparedData=prepareDataFunc(data);
    predictedLabels=classifier.predict(preparedData);
    error = score.getClassError(predictedLabels,labels,0.5);
end

