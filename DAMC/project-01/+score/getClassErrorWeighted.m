function classError =  getClassErrorWeighted(predictedClass, effectiveClass, weight)
    classError = score.getClassError(predictedClass, effectiveClass) .* weight;
end