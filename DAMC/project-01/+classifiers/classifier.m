classdef classifier
    %CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        clf
        prepareDataFunc
    end
    
    methods
        function obj = classifier(trainData,trainLabels,prepareDataFunc,clfCreator,varargin)
            %CLASSIFIER Construct an instance of this class
            %   Detailed explanation goes here
            obj.prepareDataFunc = prepareDataFunc;
            obj.clf = clfCreator(prepareDataFunc(trainData),trainLabels,varargin{:});
        end
        
        function predictedLabels = predict(obj,data)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            preparedData = obj.prepareDataFunc(data);
            predictedLabels = obj.clf.predict(preparedData);
        end
        
        function errors = classError(obj,testData, testLabels)
            predictedLabels = obj.predict(testData);
            errors = score.getClassError(predictedLabels,testLabels, 0.5);
        end
    end
end

