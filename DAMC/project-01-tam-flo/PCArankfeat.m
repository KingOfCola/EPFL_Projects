function [orderedFeatures,nbSelectedFeatures] = PCArankfeat(PasFeatures,trainDataKFold, trainLabelsKFold) 

coeffPCA = pca(trainDataKFold); % On fait une PCA avec les donn�es accessibles pour l'entra�nement
trainDataModified = trainDataKFold * coeffPCA;
        
% [coeff, score, variance] = pca(trainDataKfold);
% [lCoeff, cCoeff] = size(coeff);
% trainDataModified = zeros(lCoeff, cCoeff);
% trainDataModified = score * coeff';

[ordFeatures, orderedPowerFeatures] = rankfeat(trainDataModified, trainLabelsKFold, 'fisher'); % On fait rankfeat sur les donn�es projet�es
orderedFeatures=ordFeatures*PasFeatures;
nbSelectedFeatures = length(orderedFeatures);

end
