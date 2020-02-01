classdef inertial2orbit
    %惯性系到轨道系的坐标变换
    %   输入为Omega（升交点经度），i（轨道倾角），omega（近心点角距），单位为弧度
    %   属性包含了三个单次旋转矩阵和总的旋转矩阵
    
    properties
        MOmega3 %绕z轴旋转Omega
        Mi1 %绕x轴旋转i
        Momega3 %绕z轴旋转omega
        Minertial2orbit %惯性系到轨道系的坐标变换
        Morbit2inertal %轨道系到惯性系的坐标变换
    end
    
    methods
        function obj = inertial2orbit(Omega,i,omega)
            obj.MOmega3 = [cos(Omega),sin(Omega),0;-sin(Omega),cos(Omega),0;0,0,1];
            obj.Mi1 = [1,0,0;0,cos(i),sin(i);0,-sin(i),cos(i)]; 
            obj.Momega3 = [cos(omega),sin(omega),0;-sin(omega),cos(omega),0;0,0,1];
            obj.Minertial2orbit = obj.Momega3*obj.Mi1*obj.MOmega3;
            obj.Morbit2inertal = obj.Minertial2orbit';
        end
        
    end
end

