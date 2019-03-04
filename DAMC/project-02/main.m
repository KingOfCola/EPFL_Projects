%% Imports and global settings

clear all;
clc;
close all;

load("data/data.mat");

pTrain = 0.7;
pVal = 0.2;
d.data = Data;
d.posX = PosX;
d.posY = PosY;

data = misc.partition(d, pTrain, pVal);
t = (1:length(data.validation.posX)) * 0.05;
pos = ["posX" "posY"];

[xTrain, mu,sigma] = misc.normalize(data.train.data);

[xValidation] = misc.normalize(data.validation.data, mu, sigma);
[xTest] = misc.normalize(data.test.data, mu, sigma);

features = 1:size(data.train.data, 2);

lambdas = logspace(-6, 4, 25);
alphas = logspace(-6, 0, 25);
KFold = 10;
alpha0 = 0.5;

%% Regression X
scoresNorm = zeros(960, 2);
scoresPCA = zeros(960, 2);
scoresNorm2 = zeros(960, 2);
scoresPCA2 = zeros(960, 2);


scoresStdNorm = zeros(960, 2);
scoresStdPCA = zeros(960, 2);
scoresStdNorm2 = zeros(960, 2);
scoresStdPCA2 = zeros(960, 2);

fs = [1:30, 35:5:95, 100:100:960, 959];
features = 1:960;

coeff = pca(xTrain);
coeff2 = pca([xTrain xTrain .^2]);

validationPos = data.validation.posY;
trainPos = data.train.posY;
for f = fs
    f
    xTrainNorm = misc.dataFormat(xTrain, 1, 1:f);
    xValidationNorm = misc.dataFormat(xValidation, 1, 1:f);


    xTrainPCA = misc.dataFormat(xTrain * coeff, 1, 1:f);
    xValidationPCA = misc.dataFormat(xValidation * coeff, 1, 1:f);

    regNorm = regress(trainPos, xTrainNorm);
    regPCA = regress(trainPos, xTrainPCA);

    scoresNorm(f, 1) = score.score(xValidationNorm * regNorm, validationPos);
    scoresPCA(f, 1) = score.score(xValidationPCA * regPCA, validationPos);
    scoresStdNorm(f, 1) = score.scoreStd(xValidationNorm * regNorm, validationPos);
    scoresStdPCA(f, 1) = score.scoreStd(xValidationPCA * regPCA, validationPos);
    
    
    scoresNorm(f, 2) = score.score(xTrainNorm * regNorm, trainPos);
    scoresPCA(f, 2) = score.score(xTrainPCA * regPCA, trainPos);
    scoresNormStd(f, 2) = score.scoreStd(xTrainNorm * regNorm, trainPos);
    scoresPCAStd(f, 2) = score.scoreStd(xTrainPCA * regPCA, trainPos);
    
    
    xTrainNorm2 = misc.dataFormat(xTrain, 2, 1:f);
    xValidationNorm2 = misc.dataFormat(xValidation, 2, 1:f);


    xTrainPCA2 = misc.dataFormat([xTrain xTrain .^2] * coeff2, 1, 1:f);
    xValidationPCA2 = misc.dataFormat([xValidation xValidation .^2] * coeff2, 1, 1:f);

    regNorm2 = regress(trainPos, xTrainNorm2);
    regPCA2 = regress(trainPos, xTrainPCA2);

    scoresNorm2(f, 1) = score.score(xValidationNorm2 * regNorm2, validationPos);
    scoresPCA2(f, 1) = score.score(xValidationPCA2 * regPCA2, validationPos);
    
    scoresStdNorm2(f, 1) = score.scoreStd(xValidationNorm2 * regNorm2, validationPos);
    scoresStdPCA2(f, 1) = score.scoreStd(xValidationPCA2 * regPCA2, validationPos);
    
    
    scoresNorm2(f, 2) = score.score(xTrainNorm2 * regNorm2, trainPos);
    scoresPCA2(f, 2) = score.score(xTrainPCA2 * regPCA2, trainPos);
    
    scoresStdNorm2(f, 2) = score.scoreStd(xTrainNorm2 * regNorm2, trainPos);
    scoresStdPCA2(f, 2) = score.scoreStd(xTrainPCA2 * regPCA2, trainPos);
end

%% Plot
figure()
styles = ["-" "--"];
weights = (1 + fs / size(Data, 2)).';
colors = [[1.0 .0 .0]; [.20 .45 1.]; [.5 .0 .0]; [.0 .16 .5]]
for i = 1:1
    style = styles(i);
    p1 = plot(features(fs), weights .* scoresNorm(fs, i), style, "Color", colors(1, :), "LineWidth", 2);
    hold on
    plot(features(fs), weights .* (scoresNorm(fs, i) + scoresStdNorm(fs, i)), "--", "Color", colors(1, :));
    hold on
    plot(features(fs), weights .* (scoresNorm(fs, i) - scoresStdNorm(fs, i)), "--", "Color", colors(1, :));
    hold on
    p2 = plot(features(fs), weights .* scoresPCA(fs, i), style, "Color", colors(2, :), "LineWidth", 2);
    hold on
    plot(features(fs), weights .* (scoresPCA(fs, i) + scoresStdPCA(fs, i)), "--", "Color", colors(2, :));
    hold on
    plot(features(fs), weights .* (scoresPCA(fs, i) - scoresStdPCA(fs, i)), "--", "Color", colors(2, :));
    hold on
    p3 = plot(features(fs), weights .* scoresNorm2(fs, i), style, "Color", colors(3, :), "LineWidth", 2);
    hold on
    plot(features(fs), weights .* (scoresNorm2(fs, i) + scoresStdNorm2(fs, i)), "--", "Color", colors(3, :));
    hold on
    plot(features(fs), weights .* (scoresNorm2(fs, i) - scoresStdNorm2(fs, i)), "--", "Color", colors(3, :));
    hold on
    p4 = plot(features(fs), weights .* scoresPCA2(fs, i), style, "Color", colors(4, :), "LineWidth", 2);
    hold on
    plot(features(fs), weights .* (scoresPCA2(fs, i) + scoresStdPCA2(fs, i)), "--", "Color", colors(4, :));
    hold on
    plot(features(fs), weights .* (scoresPCA2(fs, i) - scoresStdPCA2(fs, i)), "--", "Color", colors(4, :));
end

axis([0 1500 0 inf])
xlabel("Number of features", "FontSize", 15);
ylabel("Weighted normalized MSE", "FontSize", 15);
legend([p1 p2 p3 p4], "Regression", "PCA + Regression", "Regression (order 2)", "PCA + Regression (order 2)", "FontSize", 15);


%% LASSO score function of zeros
n = 75;
nLambdas = logspace(-5, -1, n);
nZeros = zeros(n, 1);

[B, FitInfo] = lasso(xTrain, data.train.posX, "Lambda", nLambdas);
nZeros(:, 1) = sum(B ~= 0, 1);
nScores = score.score(xValidation * B + FitInfo.Intercept, data.validation.posX);

figure()
plot(nZeros, (1 + nZeros / size(xTrain, 2)) .* nScores, "LineWidth", 2)
hold on
plot(nZeros, nScores, "LineWidth", 2)
legend("Weighted score", "Score", "FontSize", 12);
xlabel("Number of non-zeros coefficients", "FontSize", 14);
ylabel("Weighted score", "FontSize", 14);

coeff = pca(xTrain);
nZerosPCA = zeros(n, 1);
xTrainPCA = xTrain * coeff;

xValidationPCA = xValidation * coeff;

[BPCA, FitInfoPCA] = lasso(xTrainPCA, data.train.posX, "Lambda", nLambdas);
nZerosPCA(:, 1) = sum(BPCA ~= 0, 1);
nScoresPCA = score.score(xValidationPCA * BPCA + FitInfo.Intercept, data.validation.posX);

figure()
plot(nZerosPCA, (1 + nZerosPCA / size(xTrainPCA, 2)) .* nScoresPCA, "LineWidth", 2)
hold on
plot(nZerosPCA, nScoresPCA, "LineWidth", 2)
legend("Weighted score", "Score", "FontSize", 12);
xlabel("Number of non-zeros coefficients", "FontSize", 14);
ylabel("Weighted score", "FontSize", 14);

%% Best scores
[sNorm, bfNorm] = min(weights .* scoresNorm(fs, 1));
[sPCA, bfPCA] = min(weights .* scoresPCA(fs, 1));
[sNorm2, bfNorm2] = min(weights .* scoresNorm2(fs, 1));
[sPCA2, bfPCA2] = min(weights .* scoresPCA2(fs, 1));

struct("Name", "Norm", "Nb_features", fs(bfNorm), "weighted_Score", sNorm, "weighted_ScoreStd", (1 + fs(bfNorm) / 960) * scoresStdNorm(fs(bfNorm), 1), "score", scoresNorm(fs(bfNorm), 1), "scoreStd", scoresStdNorm(fs(bfNorm), 1))
struct("Name", "PCA", "Nb_features", fs(bfPCA), "weighted_Score", sPCA, "weighted_ScoreStd", (1 + fs(bfPCA) / 960) * scoresStdPCA(fs(bfPCA), 1), "score", scoresPCA(fs(bfPCA), 1), "scoreStd", scoresStdPCA(fs(bfPCA), 1))
struct("Name", "Norm2", "Nb_features", fs(bfNorm2), "weighted_Score", sNorm2, "weighted_ScoreStd", (1 + fs(bfNorm2) / 960) * scoresStdNorm2(fs(bfNorm2), 1), "score", scoresNorm2(fs(bfNorm2), 1), "scoreStd", scoresStdNorm2(fs(bfNorm2), 1))
struct("Name", "PCA2", "Nb_features", fs(bfPCA2), "weighted_Score", sPCA2, "weighted_ScoreStd", (1 + fs(bfPCA2) / 960) * scoresStdPCA2(fs(bfPCA2), 1), "score", scoresPCA2(fs(bfPCA2), 1), "scoreStd", scoresStdPCA2(fs(bfPCA2), 1))


%% Plotting data
figure()
samples = 1:30;
timeLine = 0.05*samples;
nNeurons = 48;
f0 = size(Data, 2) - nNeurons;
n = 6;
p = 0.7;
mar = 0.07;
rmar = 1-mar;
width = rmar - mar;
for i=1:(n-1)
    subplot("Position", [mar (rmar-width*p*i/n) width width*p/n])
    scatter(timeLine, Data(samples, f0+i), 10,[.5 0 1], "filled")
    axis([0 inf -1 max(Data(samples, f0+i)) + 1])
    set(gca, 'xtick', [], 'ytick', [])
    ylabel("N"+i, "fontsize", 15)
end
subplot("Position", [mar mar width rmar-width*p])
scatter(timeLine, PosX(samples), 10, "filled")
hold on
scatter(timeLine, PosY(samples), 10, "filled")
set(gca, "FontSize", 11)
ylabel("Response", "fontsize", 15)
xlabel("Time", "fontsize", 11)
legend("PosX", "PosY", "fontsize", 15)

%% Covariance
samples = 1:100;
dt = misc.normalize(Data);
dt = dt(samples, :);
covar = cov(dt.');
covar = abs(covar ./ (sqrt(var(dt.')) .* sqrt(var(dt.')).'));
covar(1:10, 1:10)
size(covar)
figure()
imshow(covar)

%% LASSO
figure()
for i = 1:2
    [B, FitInfo] = lasso(xTrain, data.train.pos(:, i), "Lambda", lambdas);
    
    semilogx(lambdas, score.score(xTrain * B + FitInfo.Intercept, data.train.pos(:, i)))
    hold on
    semilogx(lambdas, score.score(xValidation * B + FitInfo.Intercept, data.validation.pos(:, i)))
    hold on
end

xlabel("Lambda")
ylabel("MSE normalized")
axis([-inf inf 0 inf])
legend("LASSO posX train", "LASSO posX validation", "LASSO posY train", "LASSO posY validation", "Location","Southeast");

%% LASSO std
figure()
posis = ["X" "Y"];
for i = 1:2
    objs = [];
    figure()
    [B, FitInfo] = lasso(xTrain, data.train.pos(:, i), "Lambda", lambdas);
    nbNonZeros = sum(B ~=0, 1);
    weights = (1 + nbNonZeros / size(B, 1)).';
    scoresTrain = score.score(xTrain * B + FitInfo.Intercept, data.train.pos(:, i));
    scoresStdTrain = score.scoreStd(xTrain * B + FitInfo.Intercept, data.train.pos(:, i)).';
    scoresValidation = score.score(xValidation * B + FitInfo.Intercept, data.validation.pos(:, i));
    scoresStdValidation = score.scoreStd(xValidation * B + FitInfo.Intercept, data.validation.pos(:, i)).';
    
    [s, ind] = min(weights .* scoresValidation);
    nbZeros = sum(B(:, ind) ~= 0);
    struct("Name", "LASSO" + posis(i), "Nb_zeros", nbZeros, "weighted_Score", s, "weighted_ScoreStd", (1 + nbZeros / 960) * scoresStdValidation(ind), "score", scoresValidation(ind), "scoreStd", scoresStdValidation(ind), "Lambda", lambdas(ind))
    
    objs = [objs, semilogx(lambdas, weights .* scoresTrain, "Color", [.98 .11 .09], "LineWidth", 2)];
    hold on
    semilogx(lambdas, weights .* (scoresTrain + scoresStdTrain), "--", "Color", [.98 .11 .09])
    hold on
    semilogx(lambdas, weights .* (scoresTrain - scoresStdTrain), "--", "Color", [.98 .11 .09])
    hold on
    objs = [objs, semilogx(lambdas, weights .* scoresValidation, "Color", [.09 .11 .98], "LineWidth", 2)];
    hold on
    semilogx(lambdas, weights .* (scoresValidation + scoresStdValidation), "--", "Color", [.09 .11 .98])
    hold on
    semilogx(lambdas, weights .* (scoresValidation - scoresStdValidation), "--", "Color", [.09 .11 .98])
    hold on

    xlabel("Lambda", "FontSize", 15)
    ylabel("Weighted normalized MSE", "FontSize", 15)
    axis([-inf inf 0 inf])
    legend(objs, "LASSO pos" + posis(i) + " train", "LASSO pos" + posis(i) + " validation", "Location","Southeast", "FontSize", 15);
end

%% Elastic nets multiple alpha 3D representation
allScores = zeros(length(alphas), length(lambdas), 2);
allAlphas = repmat(alphas.', 1, length(lambdas));
allLambdas = repmat(lambdas, length(alphas), 1);
allZeros = zeros(length(alphas), length(lambdas));


for ax = 1:2
    
    optLambdas = zeros(length(alphas), 1);
    optScores = zeros(length(alphas), 1);

    allScores = zeros(length(alphas), length(lambdas));
    for i = 1:length(alphas)
        alpha = alphas(i);
        [B, FitInfo] = lasso(xTrain, data.train.pos(:, ax), "Lambda", lambdas, "Alpha", alpha);
        scores = score.score(xValidation * B + FitInfo.Intercept, data.validation.pos(:, ax));
        [optScores(i), index] = min(scores);
        optLambdas(i) = lambdas(index);
        allScores(i, :, 1) = scores;
        allScores(i, :, 2) = score.score(xTrain * B + FitInfo.Intercept, data.train.pos(:, ax));
        allZeros(i, :) = sum(B == 0, 1);
    end
    
    sets = ["validation" "training"];
    for setIndex = 1:2
        figure()
        surf(allAlphas, allLambdas, allScores(:, :, setIndex), allScores(:, :, setIndex))
        if setIndex == 1
            hold on
            plot3(alphas, optLambdas, optScores, 'r', "LineWidth", 5)
        end
        set(gca, "xscale", "log", "yscale", "log")
        xlabel("Alpha")
        ylabel("Lambda")
        axis([-inf inf -inf inf 0 inf])
        title("Elastic nets " + sets(setIndex) + " set " + pos(ax) + " with varying alpha and lambda")
    end
    
    figure()
    for setIndex = 1:2
        surf(allAlphas, allLambdas, allScores(:, :, setIndex), allScores(:, :, setIndex), "FaceColor", "interp")
        if setIndex == 1
            hold on
            plot3(alphas, optLambdas, optScores, 'r', "LineWidth", 5)
        end
        hold on
        set(gca, "xscale", "log", "yscale", "log")
        xlabel("Alpha")
        ylabel("Lambda")
        axis([-inf inf -inf inf 0 inf])
        title("Elastic nets Training + Validation set " + pos(ax) + " with varying alpha and lambda")
    end
    
    optZeros = zeros(length(alphas), 1);
    for j = 1:length(alphas)
        optZeros(j) = allZeros(j, find(lambdas >= optLambdas(j), 1, "first"));
    end
    pos(ax)
    [s, index] = min(optScores)
    alphas(index)
    optLambdas(index)
    figure()
    surf(allAlphas, allLambdas, allZeros, allScores(:, :, 1), "FaceColor", "interp")
    hold on
    plot3(alphas, optLambdas, optZeros, 'r', "LineWidth", 5)
    set(gca, "xscale", "log", "yscale", "log")
    xlabel("Alpha")
    ylabel("Lambda")
    axis([-inf inf -inf inf 0 inf])
    title("Elastic nets zeros " + pos(ax) + " with varying alpha and lambda")
end

%% Test
[xTrainAll, muAll, sigmaAll] = misc.normalize([data.train.data; data.validation.data]);
xTestAll = misc.normalize(data.test.data, muAll, sigmaAll);
coeff = pca(xTrainAll);

nbPCs = 50;
xTrainAllPCA =  misc.dataFormat(xTrainAll * coeff, 1, 1:nbPCs);
xTestAllPCA = misc.dataFormat(xTestAll * coeff, 1, 1:nbPCs);


trainAllPos = [data.train.posY; data.validation.posY];
testAllPos = data.test.posY;
regPCA = regress(trainAllPos, xTrainAllPCA);

samples = [1:200, 300:830, 900:1286];
samples = 1:length(testAllPos);
predPos = xTestAllPCA(samples, :) * regPCA;
sc = score.score(predPos, testAllPos(samples))
scStd = score.scoreStd(predPos, testAllPos(samples))

figure()
plot(testAllPos(samples)) 
hold on
plot(predPos)
xlabel("Time")
ylabel("PosY")
legend("Effective PosY", "Predicted PosY")