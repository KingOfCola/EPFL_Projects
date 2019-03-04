
load("data/testSet.mat");
load("data/trainSet.mat");
load("data/trainLabels.mat");

cp = cvpartition(trainLabels,"kfold",10);
data.train.data = trainData(cp.training(1),:);
data.train.labels = trainLabels(cp.training(1),:);
data.test.data = trainData(cp.test(1),:);
data.test.labels = trainLabels(cp.test(1),:);

innerFolds = 40;
size(data.train.data)
cpInner = cvpartition(data.train.labels,"kfold",innerFolds);

clfs = [];

mu = struct.empty(innerFolds,0);
sigma = struct.empty(innerFolds,0);
coeff = struct.empty(innerFolds,0);
orderedFeatures = struct.empty(innerFolds,0);
thresh = 0.30;

for i=1:innerFolds
    train.data = data.train.data(cpInner.training(i),:);
    train.labels = data.train.labels(cpInner.training(i));
    test.data = data.train.data(cpInner.test(i),:);
    test.labels = data.train.labels(cpInner.test(i));
    
    [mu(i).Val, sigma(i).Val] = misc.normalization(train.data);
    coeff(i).Val = pca(misc.normalize(train.data, mu(i).Val, sigma(i).Val));
    orderedFeatures(i).Val = misc.rankfeat(train.data * coeff(i).Val, train.labels, "fisher");
    orderedFeatures(i).Corr = misc.rankfeat(train.data * coeff(i).Val, train.labels, "corr");
    clf = classifier.classifier(train,@(d)prepareData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Val(1:50)),{"discrimType","diaglinear"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    clf = classifier.classifier(train,@(d)prepareData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Val(1:50)),{"discrimType","diagquadratic"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    clf = classifier.classifier(train,@(d)selectData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Val(1:50)),{"discrimType","diaglinear","prior","uniform"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    
    clf = classifier.classifier(train,@(d)selectData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Val(1:50)),{"discrimType","diagquadratic","prior","uniform"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    clf = classifier.classifier(train,@(d)selectData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Val(1:50)),{"discrimType","diagquadratic","prior","uniform"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    
    clf = classifier.classifier(train,@(d)prepareData(d,mu(i).Val,sigma(i).Val,coeff(i).Val,orderedFeatures(i).Corr(1:100)),{"discrimType","diaglinear"});
    s = score.classError(clf.predict(test.data),test.labels)
    if s < thresh
        clfs = [clfs, struct("clf", clf)];
    end
    i
end


clfAll = classifier.classifier(data.train,@(d)prepareDataMulticlassif(d,clfs),{"discrimType","diagquadratic"});
"all"
score.classError(clfAll.predict(data.test.data),data.test.labels)

dataIm = prepareDataMulticlassif(trainData, clfs);
figure()
imshow([dataIm,repmat(clfAll.predict(trainData), 1, 20)*0.8,repmat(trainLabels, 1, 20)*0.9]);
figure()
imshow([dataIm(cp.test(1),:),repmat(clfAll.predict(trainData(cp.test(1),:)), 1, 20)*0.8,repmat(trainLabels(cp.test(1),:), 1, 20)*0.9]);

testDataIm = prepareDataMulticlassif(testData, clfs);
figure()
imshow([testDataIm,repmat(clfAll.predict(testData), 1, 20)*0.8]);




predictedTest = clfAll.predict(testData);
misc.labelToCSV(predictedTest,"test_09.csv", "results");

function preparedData = prepareData(data, mu,sigma,coeff,indexes)
    projectedData = misc.normalize(data, mu, sigma)  * coeff;
    preparedData = projectedData(:,indexes);
end


function preparedData = selectData(data, mu,sigma,coeff,indexes)
    projectedData = misc.normalize(data, mu, sigma);
    preparedData = projectedData(:,indexes);
end

function preparedData = prepareDataMulticlassif(data, clfs)
    preparedData = zeros(size(data,1),size(clfs,2));
    for i = 1:size(clfs,2)
        preparedData(:,i) = clfs(i).clf.predict(data);
    end
end