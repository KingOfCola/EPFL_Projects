function[orderedFeatures,ErrorMinTest, nbFeaturesModelTest, typeClassifierTest]= crossValidationTotale(PasFeatures, kfold, trainLabels, trainData, weight)


%discrimType = ['linear', 'diagLinear', 'diagQuadratic'];
FeatSelec = ['PCArankfeat', 'ffs'];
nbClassifiers = 3; 


%abscisse = zeros(kfold, nbFeatures);

minError = 10; 

[Matrix_TrainKFolds, Matrix_TestKFolds] = CVPartition(trainLabels, kfold);
[orderedFeatures,nbSelectedFeatures] = PCArankfeat(PasFeatures,trainData(Matrix_TrainKFolds(:,1)==1,:), trainLabels(Matrix_TrainKFolds(:,1)==1));
nbFeatures = length(orderedFeatures);
CVErrorTrain = zeros(kfold, nbFeatures, nbClassifiers);
CVErrorTest = zeros(kfold, nbFeatures, nbClassifiers);
EcartError = zeros(kfold, nbFeatures, nbClassifiers);
nbFOLDSelectedFeatures=zeros(1,nbFeatures);

for k = 1:kfold
%for fs = 1:2 %ici on boucle sur le type de features selection
        [orderedFeatures,nbKFoldSelectedFeatures] = PCArankfeat(PasFeatures,trainData(Matrix_TrainKFolds(:,k)==1,:), trainLabels(Matrix_TrainKFolds(:,k)==1));
        for j=1:nbKFoldSelectedFeatures
            cl = 0 ; 
            for discrimType = ["linear", "diaglinear", "diagquadratic"]
                cl = cl + 1 ; 
                feature = orderedFeatures(j);
                
                classifier = fitcdiscr(trainData(Matrix_TrainKFolds(:,k)==1, orderedFeatures(1:feature)), trainLabels(Matrix_TrainKFolds(:,k)==1),'discrimtype',discrimType);
                predictedLabelsTest = predict(classifier, trainData(Matrix_TestKFolds(:,k)==1,orderedFeatures(1:feature)));
                predictedLabelsTrain = predict(classifier,trainData(Matrix_TrainKFolds(:,k)==1,orderedFeatures(1:feature)));
                [classificationErrorTest,classErrorTest] = errorsPrediction(predictedLabelsTest,trainLabels(Matrix_TestKFolds(:,k)==1),weight);
                [classificationErrorTrain,classErrorTrain] = errorsPrediction(predictedLabelsTrain,trainLabels(Matrix_TrainKFolds(:,k)==1),weight);

                EcartError(k,j, cl) = abs(classErrorTrain - classErrorTest); 
                CVErrorTrain(k, j, cl) = classErrorTrain; 
                CVErrorTest(k, j, cl) = classErrorTest; 
                %abscisse(k,j) = feature ; 
            end
        end
        nbFOLDSelectedFeatures(k)=nbKFoldSelectedFeatures;
end  

nbFeaturesLim=min(nbFOLDSelectedFeatures);

 [nbFeaturesModelTest, typeClassifierTest, ErrorMinTest] = SelectionHyperparameters(CVErrorTest(:,1:nbFeaturesLim,:));
%[nbFeaturesModelTest, ClassifierTypeTest, ErrorMinTest] = SelectionHyperparameters(CVErrorTest);
if (typeClassifierTest == "l")
    typeClassifierTest = "linear"
elseif (typeClassifierTest == 'i')
    typeClassifierTest = "diaglinear"
else 
    typeClassifierTest = "diagquadratic"
end

    
end
