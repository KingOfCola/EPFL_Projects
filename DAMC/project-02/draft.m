clear all;
clc;
close all;

load("data/data.mat");

d.data = Data;
d.posX = PosX;
d.posY = PosY;

pos = ["X" "Y"];

data = misc.partition(d, 0.7);
t = (1:length(data.test.posX)) * 0.05;
meanX = repmat(mean(data.test.posX), length(data.test.posX), 1);
meanY = repmat(mean(data.test.posY), length(data.test.posY), 1);
mean = [meanX meanY];

[trainT, mu, sigma] = misc.normalize(data.train.data);
[coeff, ~, latent] = pca(trainT);
nbCoeff = misc.indThreshold(latent, 0.8);
features=1:size(Data, 2);
orders = 1:2;
legends = cell(length(orders), 1);
scores = zeros(length(orders), 2);

%% Testing2
for i = 1:2
    figure()
    j = 1;
    for order=orders
        order
        linReg = predictor.regression(data.train.data, data.train.pos(:, i),@(x) misc.dataFormat(x, order, features));

        yPredLin = linReg.predict(data.test.data);
        scores(order, 1) = linReg.score(data.test.data, data.test.pos(:, i));
        scores(order, 2) = linReg.score(data.train.data, data.train.pos(:, i));

        plot(t, yPredLin)
        hold on
        legends{j} = "Order " + order + " (" + scores(order, 1) + ")";
        j = j+1;
    end
    plot(t, mean(:, i),"k--")
    hold on 
    plot(t, data.test.pos(:, i), "linewidth", 1.5)
    legend(legends{:}, "mean ("+score.score(mean(:, i),data.test.pos(:, i)) + ")", "reality")
    title("prediction of pos" + pos(i))
    
    figure()
    plot(orders, scores(:, 1));
    hold on
    plot(orders, scores(:, 2));
    axis([1 4 0 1.5])
    title("Score Pos" + pos(i));
    xlabel("Order");
    ylabel("Score");
    legend("Test", "Train");
end
% 
% yTrainPredLinX = linRegX.predict(data.train.data);
% yTrainPredQuadX = quadRegX.predict(data.train.data);
% score.score(yTrainPredLinX,data.train.posX)
% score.score(yTrainPredQuadX,data.train.posX)
% 
% linRegY = predictor.regression(data.train.data, data.train.posY,@regressionMatLineaire);
% quadRegY = predictor.regression(data.train.data, data.train.posY,@regressionMatOrdre2);
% 
% yPredLinY = linRegY.predict(data.test.data);
% yPredQuadY = quadRegY.predict(data.test.data);
% 
% figure()
% plot(t, yPredLinY)
% hold on
% plot(t, yPredQuadY)
% hold on
% plot(t, meanY,"--")
% hold on 
% plot(t, data.test.posY, "linewidth", 1.5)
% legend("linear ("+score.score(yPredLinY,data.test.posY) + ")", "quadratic ("+score.score(yPredQuadY,data.test.posY) + ")", "mean ("+score.score(meanY,data.test.posY) + ")", "reality")
% title("prediction of posY")
% 
% 
% 
% linRegPCAY = predictor.regression(data.train.data, data.train.posY,@(x) misc.dataFormat(x * coeff(:, 1:nbCoeff), 1, 1:nbCoeff));
% quadRegPCAY = predictor.regression(data.train.data, data.train.posY,@(x) misc.dataFormat(x * coeff(:, 1:nbCoeff), 2, 1:nbCoeff));
% 
% yPredLinPCAY = linRegPCAY.predict(data.test.data);
% yPredQuadPCAY = quadRegPCAY.predict(data.test.data);
% 
% figure()
% plot(t, yPredLinPCAY)
% hold on
% plot(t, yPredQuadPCAY)
% hold on 
% plot(t, data.test.posY, "linewidth", 1.5)
% legend("linear (" + linRegPCAY.score(data.train.data, data.train.posY) + ", "+score.score(yPredLinPCAY,data.test.posY) + ")", ...
%     "quadratic (" + quadRegPCAY.score(data.train.data, data.train.posY) + ", "+score.score(yPredQuadPCAY,data.test.posY) + ")", ...
%     "reality")
% title("prediction of posY")

%% Test
nbFeatures = [1:25, 30:5:95, 100:50:size(coeff, 2)];
scoresPCA = zeros(2, length(nbFeatures), 2);
for order = 1:1
    for i = 1:length(nbFeatures)
        nbFeat = nbFeatures(i)
        regX = predictor.robustfit(data.train.data, data.train.posX,@(x) (x * coeff(:, 1:nbFeat)));
        scoresPCA(order, i, 2) = regX.score(data.test.data, data.test.posX);
        scoresPCA(order, i, 1) = regX.score(data.train.data, data.train.posX);
    end
    figure()
    plot(nbFeatures, scoresPCA(order, :, 1))
    hold on
    plot(nbFeatures, scoresPCA(order, :, 2))
    title("Scores posX with PCA + regression order " + order)
end


scores = zeros(2, length(nbFeatures), 2);
for order = 1:1
    for i = 1:length(nbFeatures)
        nbFeat = size(data.train.data, 2)-nbFeatures(i)
        regX = predictor.robustfit(data.train.data, data.train.posX,@(x) (x));
        scores(order, i, 2) = regX.score(data.test.data, data.test.posX);
        scores(order, i, 1) = regX.score(data.train.data, data.train.posX);
    end
    figure()
    plot(nbFeatures, scores(order, :, 1))
    hold on
    plot(nbFeatures, scores(order, :, 2))
    title("Scores posX with regression order " + order)
end

nbFeatures = 1:50:size(data.train.data, 2);
scores = zeros(2, length(nbFeatures), 2);
for order = 1:2
    for i = 1:length(nbFeatures)
        nbFeat = size(data.train.data, 2)-nbFeatures(i);
        regY = predictor.regression(data.train.data, data.train.posY,@(x) misc.dataFormat(x, order, nbFeat:size(data.train.data, 2)));
        scores(order, i, 2) = regY.score(data.test.data, data.test.posY);
        scores(order, i, 1) = regY.score(data.train.data, data.train.posY);
    end
    figure()
    plot(nbFeatures, scores(order, :, 1))
    hold on
    plot(nbFeatures, scores(order, :, 2))
    title("Scores posY with regression order " + order)
end
