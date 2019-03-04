classdef robustfit
    %REGRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mu
        sigma
        b
        transformFun
    end
    
    methods
        function obj = robustfit(x,y,transformFun)
            %REGRESSION Construct an instance of this class
            %   Detailed explanation goes here
            obj.mu = mean(x, 1);
            obj.sigma = std(x, 1, 1);
            obj.transformFun = transformFun;
            obj.b = robustfit(obj.preprocess(x), y);
        end
        
        function xT = preprocess(obj, x)
            xT = obj.transformFun((x - obj.mu) ./ obj.sigma);
        end
        
        function s = score(obj, x, y)
            s = score.score(obj.predict(x), y);
        end
        
        function yPred = predict(obj,x)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            yPred = obj.b(1) + obj.preprocess(x) * obj.b(2:end);
        end
    end
end

