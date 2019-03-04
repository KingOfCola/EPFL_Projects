function [btrain,mu,sigma] = regression(datatrain, posX)

mu = mean(datatrain, 1);
sigma = std(datatrain, 0, 1);
Xtrain_linear = regressionMatLineaire((datatrain-mu) ./ sigma);

btrain = regress(posX, Xtrain_linear); % quel ordre train/test? 

end
