
function [NestedCVErrorTestOuters,nbFeaturesOptOuters, typeClassifierOpt]= NestedCV(nbOuters,nbInners, trainLabels, trainData, weight)

[Matrix_OuterTrain, Matrix_OuterTest] = CVPartition(trainLabels, nbOuters); %partition en outers
nbFeaturesOptOuters = zeros(nbOuters, 1);
NestedCVErrorTestOuters = zeros(nbOuters,1);
typeClassifierOpt = zeros(nbOuters,1);
for k = 1:nbOuters
        [orderedFeatures,InnerErrorMin, nbFeaturesModel, typeClassifier]= crossValidationTotale(PasFeature,nbInners, trainLabels(Matrix_OuterTrain(:,k)==1), trainData, weight)
        classifier = fitcdiscr(trainData(Matrix_OuterTrain(:,k)==1, orderedFeatures(1:nbFeaturesModel)), trainLabels(Matrix_OuterTrain(:,k)==1),'discrimtype',typeClassifier);
        predictedLabelsTest = predict(classifier, trainData(Matrix_OuterTest(:,k)==1,orderedFeatures(1:nbFeaturesModel)));
        [classificationErrorTestOuter,classErrorTestOuter] = errorsPrediction(predictedLabelsTest,trainLabels(Matrix_OuterTest(:,k)==1),weight);
       
        
        
        nbFeaturesOptOuters(k,1) = nbFeaturesModel ; 
        typeClassifierOpt(k,1) = typeClassifier ;
        NestedCVErrorTestOuters(k,1)=classErrorTestOuter;
end

end
