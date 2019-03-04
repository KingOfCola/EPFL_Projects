function [frequenceFeatures] = FeaturesSelectionForward(trainData, trainLabels, kfold)

IndMaxFeatures = 2000; 
PasFeatures = 5; 
nbMaxSelectedFeatures = 100; 
SelectedFeatures = zeros(1,IndMaxFeatures/PasFeatures);
matriceSelectedFeatures = zeros(nbIt, nbMaxSelectedFeatures); 
frequenceFeatures = zeros(1,2048);


    [SelectedFeaturesSeq,History] = sequentialfs(@(trainData,trainLabels,testData,testLabels) length(trainLabels)*(errorsPrediction(testLabels,predict(fitcdiscr(trainData,trainLabels,'discrimtype', 'diaglinear'), testData), 0.5)),trainData(:,[1:PasFeatures:IndMaxFeatures]), trainLabels, 'cv',kfold);

    SelectedFeatures = find(SelectedFeaturesSeq == 1);
    NbSelectedFeatures = length(SelectedFeatures);  

    SelectedFeaturesFinal = zeros(1,nbMaxSelectedFeatures);

    for k= 1:NbSelectedFeatures
        SelectedFeaturesFinal(k) = PasFeatures*SelectedFeatures(k)+1; 
    end

    matriceSelectedFeatures(r,:)=SelectedFeaturesFinal; 
    

 for f = 1:2048
    frequenceFeatures(f) = length(find(matriceSelectedFeatures==f));
end


end
