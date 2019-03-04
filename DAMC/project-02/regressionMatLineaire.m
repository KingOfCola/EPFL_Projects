function [X_linear] = regressionMatLineaire(data)

I = ones(size(data, 1), 1);
FM = data;

X_linear = [I FM];

end
