function [X_ordre2] = regressionMatOrdre2(datatrain)

I = ones(size(datatrain, 1), 1);
FM = datatrain;

X_ordre2 = [I FM FM.^2];

end
