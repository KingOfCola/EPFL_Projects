function results = nestedCrossValidation(data,classifierGroceries,outerFolds,innerFolds,scoreFun)
%NESTEDCROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    callback = generateClfGroceryCallback(classifierGroceries, innerFolds, scoreFun);
    results = validation.crossValidation(data,outerFolds,callback);
end

function bestClfGroceryCallback = generateClfGroceryCallback(classifierGroceries,innerFolds,scoreFun)
    bestClfGroceryCallback = @(d)validation.getBestClassifierGrocery(d.train,classifierGroceries,innerFolds,scoreFun);
end