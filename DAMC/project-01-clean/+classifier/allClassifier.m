classdef allClassifier
    %ALLCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        clfs
        allClf
    end
    
    methods
        function obj = allClassifier(data,clfs,clfProps)
            %ALLCLASSIFIER Construct an instance of this class
            %   Detailed explanation goes here
            obj.clfs = clfs;
            obj.allClf = classifier.classifier(data,@obj.prepareData,clfProps);
        end
        
        function preparedData = prepareData(obj,data)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            preparedData = zeros(size(data,1),length(obj.clfs));
            for clfIndex = 1:length(obj.clfs)
                preparedData(:,clfIndex) = obj.clfs(clfIndex).predict(data);
            end
        end
        
        function predictedLabels = predict(obj, data)
            predictedLabels = obj.allClf.predict(data);
        end
    end
end

