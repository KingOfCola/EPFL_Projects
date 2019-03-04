function confusionMatrix = getConfusionMatrix(predictedClass, effectiveClass)
    %% Returns the confusion matrix based on predicted and effective class of each sample.
    % cm(predictedClass, effectiveClass) contains the number of samples
    % predicted as predictedClass but effectively from effectiveClass
    nbSamples = length(predictedClass);
    confusionMatrix = [0 0; 0 0];
    for sample = 1:nbSamples
        confusionMatrix(predictedClass(sample) +1, effectiveClass(sample) +1) = ...
            confusionMatrix(predictedClass(sample) +1, effectiveClass(sample) +1)+1;
    end
end