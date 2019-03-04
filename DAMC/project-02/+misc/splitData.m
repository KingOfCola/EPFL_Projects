function splittedData = splitData(data,train)
%SPLITDATA Summary of this function goes here
%   Detailed explanation goes here
    test = ~train;
    splittedData.train.data = data.data(train,:);
    splittedData.train.posX = data.posX(train);
    splittedData.train.posY = data.posY(train);
    splittedData.train.pos = [data.posX(train) data.posY(train)];
    
    splittedData.test.data = data.data(test,:);
    splittedData.test.posX = data.posX(test);
    splittedData.test.posY = data.posY(test);
    splittedData.test.pos = [data.posX(test) data.posY(test)];
end

