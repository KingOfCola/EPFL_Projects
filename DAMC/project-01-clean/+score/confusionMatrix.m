function confusionMat = confusionMatrix(predictedLabels,effectiveLabels)
%CONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here
    confusionMat = zeros(2);
    for i=1:length(predictedLabels)
        pL = predictedLabels(i) + 1;
        eL = effectiveLabels(i) + 1;
        confusionMat(pL, eL) = confusionMat(pL, eL) + 1;
    end
end

