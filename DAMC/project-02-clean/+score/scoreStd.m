function stdError = scoreStd(yPred,yEff)
%SCORESTD Summary of this function goes here
%   Detailed explanation goes here
    s = (yPred - yEff) .^ 2;
    stdError = std(s,0, 1) / std(yEff);
end

