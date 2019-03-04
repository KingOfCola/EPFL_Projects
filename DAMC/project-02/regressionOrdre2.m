function [btrain,mu,sigma] = regressionOrdre2(datatrain, posX)

mu = mean(datatrain, 1);
sigma = std(datatrain, 0, 1);
Xtrain_Ordre2 = regressionMatOrdre2((datatrain-mu) ./ sigma);

btrain = regress(posX, Xtrain_Ordre2); % quel ordre train/test? 

end
