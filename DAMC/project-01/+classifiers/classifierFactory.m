classdef classifierFactory
    %CLASSIFIERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        clfParameters
        prepareDataFuncFunc
    end
    
    methods
        function obj = classifierFactory(prepareDataFuncFunc,varargin)
            %CLASSIFIERFACTORY Construct an instance of this class
            %   Detailed explanation goes here
            obj.prepareDataFuncFunc = prepareDataFuncFunc;
            obj.clfParameters = varargin;
        end
        
        function clf = fit(obj, trainData,trainLabels)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            prepareDataFunc = obj.prepareDataFuncFunc(trainData, trainLabels);
            clf = classifiers.classifier(trainData,trainLabels,prepareDataFunc,@fitcdiscr,obj.clfParameters{:});
        end
    end
end

