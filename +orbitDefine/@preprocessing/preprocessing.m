classdef preprocessing
    %对观测数据进行预处理
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = preprocessing(A,E,B,H,s)
 
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        function C = station2inertial(obj,s_,B_)
            % 测站地平坐标系到地心惯性坐标系的转换,输入单位为deg
            s_ = s_/180*pi;
            B_ = B_/180*pi;
            C=[-sin(s_),-cos(s_)*sin(B_),cos(s_)*cos(B_);cos(s_),-sin(s_)*sin(B_),sin(s_)*cos B_;0,cos(B_),sin(B_)];
        end
    end
end

