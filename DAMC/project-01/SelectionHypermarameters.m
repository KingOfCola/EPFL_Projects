function [nbFeaturesModel, ClassifierType, ErrorMin] = SelectionHypermarameters(ErrorMatrix)

[nbFolds, nbFeatures, nbClassifiers] = size(ErrorMatrix);

Classifier = ["linear","diaglinear", "diagquadratic"];
averageError = zeros(nbFeatures, nbClassifiers); 

for cl = 1:nbClassifiers
        averageError(:,cl) = mean(ErrorMatrix(:,:,cl),1) ;
end

ErrorMinCl = min(averageError, 1);
ErrorMin = min(ErrorMinCl);
[nbFeaturesModel, numeroClassifier] = find(averageError == ErrorMin) ; 

ClassifierType = Classifier(numeroClassifier);

end

