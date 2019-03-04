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
classificationError = (nbFalsePredictCorrect + nbFalsePredictWrong) ./ (nbCorrect + nbWrong);
classError = (correctWeight) * nbFalsePredictCorrect / (1. * nbCorrect) + (1.-correctWeight) * nbFalsePredictWrong / nbWrong;
end 