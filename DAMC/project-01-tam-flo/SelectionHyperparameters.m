function [nbFeaturesModel, ClassifierType, ErrorMin] = SelectionHyperparameters(ErrorMatrix)

[nbFolds, nbFeatures, nbClassifiers] = size(ErrorMatrix);

Classifier = ["linear","diaglinear", "diagquadratic"];
averageError = zeros(nbFeatures, nbClassifiers); 

for cl = 1:nbClassifiers
        averageError(:,cl) = mean(ErrorMatrix(:,:,cl)) ;
end


ErrorMinCl = min(averageError);
ErrorMin = min(ErrorMinCl);

[nbFeaturesModel, numeroClassifier] = find(averageError == ErrorMin, 1) ; 

ClassifierType = Classifier(numeroClassifier);

end

