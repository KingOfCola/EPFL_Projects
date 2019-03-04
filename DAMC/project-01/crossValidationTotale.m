function[ErrorMinTrain, nbFeaturesModelTrain, typeClassifierTrain]= crossValidationTotale(kfold, trainLabels, trainData, weight)

nbSelectedFeaturesPCA = length(trainLabels)-1;
nbSelectedFeaturesPCA = 8;
discrimType = ["linear", "diagLinear", "diagQuadratic"];
FeatSelec = ["PCArankfeat", "ffs"];
nbClassifiers = 3; 

CVErrorTrain = zeros(kfold, nbSelectedFeaturesPCA, nbClassifiers);
CVErrorTest = zeros(kfold, nbSelectedFeaturesPCA, nbClassifiers);
%abscisse = zeros(kfold, nbFeatures);
EcartError = zeros(kfold, nbSelectedFeaturesPCA, nbClassifiers);
minError = 10; 

cp = cvpartition(trainLabels,"kfold", kfold);


for k = 1:kfold
%for fs = 1:2 %ici on boucle sur le type de features selection
        trainDataKFold = trainData(cp.training(k),:); % Juste les data train pour le fold en cours
        trainLabelsKFold = trainLabels(cp.training(k)); % Juste les labels train pour le fold en cours
        
        testDataKFold = trainData(cp.test(k),:); % Juste les data test pour le fold en cours
        testLabelsKFold = trainLabels(cp.test(k)); % Juste les labels test pour le fold en cours
        
        coeffPCA = pca(trainDataKFold); % On fait une PCA avec les données accessibles pour l'entraînement
        trainDataModified = trainDataKFold * coeffPCA; % On projette les data train sur la PCA pour le fold en cours
        [orderedFeatures, orderedPowerFeatures] = rankfeat(trainDataModified, trainLabelsKFold, 'fisher'); % On fait rankfeat sur les données projetées
        nbSelectedFeaturesPCA = 8;
        for j=1:nbSelectedFeaturesPCA
            cl = 0 ; 
            j
            for discrimType = ["linear" "diaglinear" "diagquadratic"]
                cl = cl + 1 ; 
                feature = orderedFeatures(j);
                classifier = fitcdiscr(trainDataKFold(:, orderedFeatures(1:feature)), trainLabelsKFold,'discrimtype',discrimType);
                predictedLabelsTest = predict(classifier, testDataKFold(:,orderedFeatures(1:feature)));
                predictedLabelsTrain = predict(classifier,trainDataKFold(:,orderedFeatures(1:feature)));
                classErrorTest = getClassError(predictedLabelsTest,testLabelsKFold,weight);
                classErrorTrain = getClassError(predictedLabelsTrain,trainLabelsKFold,weight);

                EcartError(k,j, cl) = abs(classErrorTrain - classErrorTest); 
                CVErrorTrain(k, j, cl) = classErrorTrain; 
                CVErrorTest(k, j, cl) = classErrorTest; 
                %abscisse(k,j) = feature ; 
            end
        end
end  

 [nbFeaturesModelTrain, typeClassifierTrain, ErrorMinTrain] = SelectionHypermarameters(CVErrorTrain);
%[nbFeaturesModelTest, ClassifierTypeTest, ErrorMinTest] = SelectionHyperparameters(CVErrorTest);
end

function classErrors =  getClassError(predictedClass, effectiveClass, varargin)
    if (length(varargin) >= 1)
        correctWeight = varargin{1};
    else
        correctWeight = 0.5;
    end
    confusionMatrix = score.getConfusionMatrix(predictedClass, effectiveClass);
    classErrors = correctWeight * confusionMatrix(1, 2) / (confusionMatrix(1, 2) + confusionMatrix(2, 2)) + (1 - correctWeight) * confusionMatrix(2, 1) / (confusionMatrix(1, 1) + confusionMatrix(2, 1));
end