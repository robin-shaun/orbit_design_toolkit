classdef usingMultiPos_contrast
    %适用于观测量为方位角、仰角和距离的情况，初始化输入为地心惯性系下航天器三维坐标序列。
    %   第一步求三维偏心率矢量和半通径
    %   第二步根据共面条件求轨道面法向量
    %   第三步求其余轨道参数
    
    properties
        a %半长轴
        e %偏心率
        omega %近心点角距
        Omega %升交点经度
        i %轨道倾角
        tao %过近心点时刻
        f0 %序列首历元的真近点角
        E0 %序列首历元的偏近点角
        M0 %序列首历元的平近点角
        p %半通经
    end
    
    methods
        function obj = usingMultiPos_contrast(spacecraftpos,UTC)
            %构造函数
            import constants.AstroConstants
            %求三维偏心率矢量和半通径
            A = [spacecraftpos,-ones(length(spacecraftpos(:,1)),1)];
            b = -vecnorm(spacecraftpos')';
            tmp = lsqminnorm(A,b,'warn');
            e = tmp(1:3);
            obj.e = norm(e);
            obj.p = tmp(4);
            %根据共面条件求轨道面法向量
            A = spacecraftpos(:,1)-e(1)/e(2)*spacecraftpos(:,2);
            b = e(3)/e(2)*spacecraftpos(:,2)-spacecraftpos(:,3);
            nx = lsqminnorm(A,b,'warn');
            n = [nx,-e(1)/e(2)*nx-e(3)/e(2),1];
            %求其余轨道参数
            obj.a = obj.p/(1-obj.e^2);
            obj.i = acos(1/norm(n));
            obj.Omega = atan(-n(1)/n(2));
            obj.omega = atan(e(3)/(e(2)*sin(obj.Omega)+e(1)*cos(obj.Omega))/sin(obj.i));
            u0 = atan2(spacecraftpos(1,3),(spacecraftpos(1,2)*sin(obj.Omega)+spacecraftpos(1,1)*cos(obj.Omega))*sin(obj.i));
            obj.f0 = u0 - obj.omega;
            if(obj.f0<0)
                obj.f0=2*pi+obj.f0;
            end
            obj.E0 = 2*atan(tan(obj.f0/2)*sqrt((1-obj.e)/(1+obj.e)));
            if(abs(obj.E0-obj.f0)>pi/2)
                if(abs(obj.E0+pi-obj.f0)>pi/2)
                    obj.E0 = obj.E0 + 2*pi;
                else
                    obj.E0 = obj.E0 + pi;
                end
            end
            obj.M0 = obj.E0-obj.e*sin(obj.E0);
            obj.tao = UTC(1)-obj.M0*sqrt(obj.a^3/AstroConstants.GM)/3600/24;

            %单位转换
            obj.i = obj.i*180/pi;
            obj.Omega = obj.Omega*180/pi;
            obj.omega = obj.omega*180/pi;
            obj.f0 = obj.f0*180/pi;
            obj.E0 = obj.E0*180/pi;
            obj.M0 = obj.M0*180/pi;
        end
       
    end
end

