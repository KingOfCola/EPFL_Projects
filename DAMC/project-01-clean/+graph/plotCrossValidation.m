function plotCrossValidation(bestClassif,x,figureName)
%PLOTCROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
    [xMesh1, trainScores] = misc.meshgrid(x,bestClassif.trainScores);
    [xMesh2, testScores] = misc.meshgrid(x,bestClassif.validationScores);
    figure("Name", figureName)
    scatter(xMesh1,trainScores,10,[0.5 0.5 1])
    hold on
    plot(x,mean(bestClassif.trainScores,1),"Color",[0 0 1])
    hold on
    scatter(xMesh2,testScores,10,[1 0.5 0.5])
    hold on
    plot(x,mean(bestClassif.validationScores,1),"Color",[1 0 0])
    hold on
    scatter(x(bestClassif.index),bestClassif.score,100, "filled")
    hold on
    plot(x,mean(bestClassif.scores,1),"Color",[0 0.8 0])
    hold on
    ylim([0, 1])
    xlabel("Number of features")
    ylabel("Error")
    legend("Train error", "Train error mean", "Test error", "Test error mean", "Best number of features", "Weighted error mean")
end

