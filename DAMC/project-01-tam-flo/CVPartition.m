function [Matrix_IndTrainKFolds, Matrix_IndTestKFolds] = CVPartition(trainLabels, kfold)
   %ATTENTION : les fois où on ne veut faire la cross que sur certains samples, il faudra marquer en paramètre trainLabels(SAMPLEconcernés)
   %ET ATTENTION en sortie on a des matrices ! En ligne : les samples
   % correspondants au KFOLD (colonne)
   rng(1);
   nbSamples=length(trainLabels);
    Matrix_IndTrainKFolds = zeros(nbSamples,kfold);
    Matrix_IndTestKFolds = zeros(nbSamples,kfold);
    scores = zeros(kfold, 1);
    crossPartition = cvpartition(trainLabels, 'kfold', kfold);
    for i = 1:kfold
        trainK = crossPartition.training(i);
        Matrix_IndTrainKFolds(:,i) = (trainK == 1); 
        testK = crossPartition.test(i);
        Matrix_IndTestKFolds(:,i) = (testK == 1); 
    end       
end