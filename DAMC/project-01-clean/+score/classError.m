function error = classError(predictedLabels,effectiveLabels, varargin)
%CLASSERROR Summary of this function goes here
%   Detailed explanation goes here
    if length(varargin) == 1
        w = varargin{1};
    else
        w = 0.5;
    end
    cM = score.confusionMatrix(predictedLabels,effectiveLabels);
    error = w * cM(2, 1) / (cM(1, 1) + cM(2, 1)) + (1 - w) * cM(1, 2) / (cM(1, 2) + cM(2, 2));
end

