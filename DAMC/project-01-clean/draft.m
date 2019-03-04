close 'all';
index = zeros(10*40,1);
scores = zeros(10*40, 1);
clfs = [];
cp = cvpartition(trainLabels, "kfold",10);
dataAll = misc.splitData(data, cp, 1);
cp2 = cvpartition(dataAll.train.labels, "kfold", 40);
for fold = 1:40
    dataTrain = misc.splitData(dataAll.train, cp2, fold);
    fold
    for i=1:10
        index(10*(fold-1)+i) = results(i).Value.index;
        scores(10*(fold-1)+i) = results(i).Value.score;
        clfFactory = results(i).Value.factory.grocery.createClassifierFactory(data);
        hyperParams = results(i).Value.factory.hyperParams;
        clf = clfFactory.createClassifier(dataTrain.train, hyperParams);
        scores(10*(fold-1)+i) = score.classError(clf.predict(dataTrain.test.data), dataTrain.test.labels);
        if scores(10*(fold-1)+i) < 0.4
            clfs = [clfs, clf];
        end
    end
end
index
scores
clf = classifier.allClassifier(dataAll.test,clfs,{"discrimType","diagquadratic","prior","uniform"});
score.classError(clf.predict(dataAll.test.data), dataAll.test.labels)
figure()
imshow([clf.prepareData(dataAll.train.data),repmat(clf.predict(dataAll.train.data), 1, 20)*0.8]);
figure()
imshow([clf.prepareData(dataAll.test.data),repmat(clf.predict(dataAll.test.data), 1, 20)*0.8]);
figure()
imshow([clf.prepareData(testData),repmat(clf.predict(testData), 1, 20)*0.8]);
predictedTest = clf.predict(testData);
misc.labelToCSV(predictedTest,"test_09.csv", "results");