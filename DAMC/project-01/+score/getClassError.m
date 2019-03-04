function classErrors =  getClassError(predictedClass, effectiveClass, varargin)
    if (length(varargin) >= 1)
        correctWeight = varargin{1};
    else
        correctWeight = 0.5;
    end
    confusionMatrix = score.getConfusionMatrix(predictedClass, effectiveClass);
    classErrors = correctWeight * confusionMatrix(1, 2) / (confusionMatrix(1, 2) + confusionMatrix(2, 2)) + (1 - correctWeight) * confusionMatrix(2, 1) / (confusionMatrix(1, 1) + confusionMatrix(2, 1));
end