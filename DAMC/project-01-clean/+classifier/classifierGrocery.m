classdef classifierGrocery
    %CLASSIFIERGROCERY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prepareDataFunFactory
        precomputedHyperParamsFun
        clfProps
    end
    
    methods
        function obj = classifierGrocery(prepareDataFunFactory,precomputedHyperParamsFun,clfProps)
            %CLASSIFIERGROCERY Construct an instance of this class
            %   prepareDataFunFactory is a function eating a hyperparameter 
            %   configuration and precomputedhyperparameters returning a 
            %   function preparing data
            %   preparing the data with a good shape
            %   precomputedHyperParamsFun is a function eating data and
            %   returning precomputed hyper params based on this data.
            obj.prepareDataFunFactory = prepareDataFunFactory;
            obj.precomputedHyperParamsFun = precomputedHyperParamsFun;
            obj.clfProps = clfProps;
        end
        
        function clfFactory = createClassifierFactory(obj,trainData)
            %createClassifierFactory creates a classifier factory with
            %precomputed parameters computed on base of trainData.
            clfFactory = classifier.classifierFactory(@obj.prepareDataFunFactory, obj.precomputedHyperParamsFun(trainData),obj.clfProps);
        end
    end
end

