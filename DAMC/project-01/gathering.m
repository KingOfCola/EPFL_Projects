%% Fonctions auxiliaires
function gather = gathering()
    gather =struct('getClassesIndices', getClassesIndices, 'getErrors', getErrors);
end


function [classificationError, classError] = errors(featuresCorrect, featuresWrong, threshold, correctWeight)
    [nbCorrect] = size(featuresCorrect);
    [nbWrong] = size(featuresWrong);
    [nbFalsePredictCorrect] = size(find(featuresCorrect >= threshold));
    [nbFalsePredictWrong] = size(find(featuresWrong < threshold));
    classificationError = (nbFalsePredictCorrect + nbFalsePredictWrong) / (nbCorrect + nbWrong);
    classError = (correctWeight) * nbFalsePredictCorrect / (1. * nbCorrect) + (1.-correctWeight) * nbFalsePredictWrong / nbWrong;
end

function [classificationErrors, classErrors] = getErrors(featuresCorrect, featuresWrong, nbThresholds, correctWeights)
    [ligne,weightInd]=size(correctWeights);
    classificationErrors = zeros(nbThresholds+1,weightInd);
    classErrors = zeros(nbThresholds+1,weightInd);
    for particularWeight=1:weightInd
        for (i = 0:nbThresholds)
            threshold = i/nbThresholds;
            [classificationErrors(i+1,particularWeight), classErrors(i+1,particularWeight)] = errors(featuresCorrect, featuresWrong, threshold, correctWeights(particularWeight));
        end
    end
end




function [classErrors] =  getClassErrorsFromPrediction(predictedClass, effectiveClass, correctWeights)
    [confusionMatrix] = getConfusionMatrixFromPrediction(predictedClass, effectiveClass);
    classErrors = correctWeights * confusionMatrix(1, 2) / (confusionMatrix(1, 2) + confusionMatrix(2, 2)) + (1 - correctWeights) * confusionMatrix(2, 1) / (confusionMatrix(1, 1) + confusionMatrix(2, 1));
end

function [classificationErrors] =  getClassificationErrorsFromPrediction(predictedClass, effectiveClass)
    [confusionMatrix] = getConfusionMatrixFromPrediction(predictedClass, effectiveClass);
    classificationErrors = (confusionMatrix(1, 2) + confusionMatrix(2, 1)) / (sum(confusionMatrix, 'all'));
end

function [thresh]=getThreshold(trainCorrect, trainWrong, feature1, feature2,weight)
    nbThreshs = 60;
    threshs = (0:nbThreshs) *1./ nbThreshs;
    [classificationErrors, classErrors] = getErrors(trainCorrect(:, feature1), trainWrong(:, feature1), nbThreshs, weight);
    [classError, idThresh] = min(classErrors);
    thresh = threshs(idThresh);
end

function plotscatter(trainCorrect, trainWrong, feature1, feature2, weight)
    thresh = getThreshold(trainCorrect, trainWrong, feature1, feature2,weight);
    
    figure()
    scatter(trainCorrect(:, feature1), trainCorrect(:, feature2), 30, [0 0.8 0.2]);
    hold on
    scatter(trainWrong(:, feature1), trainWrong(:, feature2), 30, [1 0 0]);
    hold on
    plot([thresh(1), thresh(1)], [0, 1], 'r--', 'Color', [0 0 0]);
    xlabel("feature " + feature1);
    ylabel("feature " + feature2);
    title('Plot of two features and first threshold');
    legend("Correct", "Wrong");
end