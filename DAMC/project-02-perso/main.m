load("data/data.mat");

d.data = Data;
d.posX = PosX;
d.posY = PosY;

data = misc.partition(d, 0.7);

size(data.train.data)
size(data.test.data)

I = ones(size(data.train.posX, 1), 1);
FM = data.train.data;

X = [I FM];
XTest = [ones(size(data.test.posX, 1), 1) data.test.data];
size(X)

b = regress(data.train.posX, X);
errorTrain = immse(data.train.posX, X*b)
errorTest = immse(data.test.posX, XTest*b)