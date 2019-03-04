classdef classifierFactory
    %CLASSIFIERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prepareDataFunFactory %function eating hyperparam and precomputedHyperParams
        precomputedHyperParams %struct given to prepareDataFunFactory
        clfProps
    end
    
    methods
        function obj = classifierFactory(prepareDataFunFactory,precomputedHyperParams,clfProps)
            %CLASSIFIERFACTORY Construct an instance of this class
            %   Detailed explanation goes here
            obj.prepareDataFunFactory = prepareDataFunFactory;
            obj.precomputedHyperParams = precomputedHyperParams;
            obj.clfProps = clfProps;
        end
        
        function clf = createClassifier(obj,trainData,hyperParam)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            clf = classifier.classifier(trainData, obj.prepareDataFunFactory(hyperParam, obj.precomputedHyperParams),obj.clfProps);
        end
    end
end

