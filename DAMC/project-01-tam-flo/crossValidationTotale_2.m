function[ErrorMinTrain, nbFeaturesModelTrain, typeClassifierTrain]= crossValidationTotale(kfold, trainLabels, trainData, weight)

nbFeatures = length(trainLabels);
discrimType = ["linear", "diagLinear", "diagQuadratic"];
FeatSelec = ["PCArankfeat", "ffs"];
nbClassifiers = 3; 

CVErrorTrain = zeros(kfold, nbFeatures, nbClassifiers);
CVErrorTest = zeros(kfold, nbFeatures, nbClassifiers);
%abscisse = zeros(kfold, nbFeatures);
EcartError = zeros(kfold, nbFeatures, nbClassifiers);
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
        nbSelectedFeaturesPCA = size(coeffPCA,2);
        %for j=1:nbSelectedFeaturesPCA
        for j=1:10
            cl = 0 ; 
            for discrimType = ["linear" "diaglinear" "diagquadratic"]
                cl = cl + 1 ; 
                feature = orderedFeatures(j);
                discrimType
                classifier = fitcdiscr(trainDataKFold(:, orderedFeatures(1:feature)), trainLabelsKFold,'discrimtype',discrimType);
                predictedLabelsTest = predict(classifier, testDataKFold(:,orderedFeatures(1:feature)));
                predictedLabelsTrain = predict(classifier,trainDataKFold(:,orderedFeatures(1:feature)));
                [classificationErrorTest,classErrorTest] = errorsPrediction(predictedLabelsTest,testLabelsKFold,weight);
                [classificationErrorTrain,classErrorTrain] = errorsPrediction(predictedLabelsTrain,trainLabelsKFold,weight);

                EcartError(k,j, cl) = abs(classErrorTrain - classErrorTest); 
                CVErrorTrain(k, j, cl) = classErrorTrain; 
                CVErrorTest(k, j, cl) = classErrorTest; 
                %abscisse(k,j) = feature ; 
            end
        end
end  

 [nbFeaturesModelTrain, ClassifierTypeTrain, ErrorMinTrain] = SelectionHyperparameters(CVErrorTrain);
%[nbFeaturesModelTest, ClassifierTypeTest, ErrorMinTest] = SelectionHyperparameters(CVErrorTest);
end
