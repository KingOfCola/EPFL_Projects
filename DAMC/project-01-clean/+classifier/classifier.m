classdef classifier
    %CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        clf
        prepareDataFun
    end
    
    methods
        function obj = classifier(trainData, prepareDataFun, clfProps)
            %CLASSIFIER Construct an instance of this class
            %   Detailed explanation goes here
            obj.prepareDataFun = prepareDataFun;
            obj.clf = fitcdiscr(prepareDataFun(trainData.data), trainData.labels,clfProps{:});
        end
        
        function predicted = predict(obj,testData)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            predicted = predict(obj.clf, obj.prepareDataFun(testData));
        end
    end
end

