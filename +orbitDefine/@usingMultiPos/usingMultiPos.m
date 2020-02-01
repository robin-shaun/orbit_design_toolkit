classdef usingMultiPos
    %适用于观测量为方位角、仰角和距离的情况，初始化输入为地心惯性系下航天器三维坐标序列。
    %   第一步先确定轨道面（升交点经度和轨道面倾角）
    %   第二步确定圆锥曲线（半长轴、偏心率和近心点角距）
    
    properties
        a %半长轴
        e %偏心率
        Omega %升交点经度
        omega %近心点角距
        i %轨道倾角
        tao %过近心点时刻
        f0 %序列首历元的真近点角
        E0 %序列首历元的偏近点角
        M0 %序列首历元的平近点角
        p %半通经
    end
    
    methods
        function obj = usingMultiPos(spacecraftpos,UTC)
            %构造函数
            import constants.AstroConstants
            %1.确定轨道面
            %利用最小二乘法求解轨道面法向量
            %设轨道平面：nx*x+ny*y+z=0,(nx,ny,1)为法向量
            A = [spacecraftpos(:,1),spacecraftpos(:,2)];
            b = -spacecraftpos(:,3);
            n_xy = lsqminnorm(A,b,'warn');
            n = [n_xy;1];
            obj.i = acos(1/norm(n));
            obj.Omega = atan(-n(1)/n(2));
            
            %2.确定圆锥曲线（半长轴、偏心率和近心点角距）
            %求航天器在经过前两次旋转后的坐标系下的坐标
            transform = coordinateTransformation.inertial2orbit(obj.Omega,obj.i,0);
            Mi1= transform.Mi1;
            MOmega3 = transform.MOmega3;
            newpos = (Mi1*MOmega3*spacecraftpos')';
            newpos = newpos(:,1:2);
            %利用最小二乘法求偏心率矢量和半通径
            A = [newpos,-ones(length(newpos(:,1)),1)];
            b = -vecnorm(newpos')';
            tmp = lsqminnorm(A,b,'warn');
            e2_ = tmp(1:2);
            obj.e = norm(e2_);
            obj.omega = atan2(e2_(2),e2_(1));
            obj.p = tmp(3);
            obj.a = obj.p/(1-obj.e^2);
            tmp = cross([e2_;0],[newpos(1,1:2),0]);
            if(sign(tmp(3))>0)
                obj.f0 = acos(dot(e2_,newpos(1,1:2))/norm(e2_)/norm(newpos(1,1:2)));
            else
                obj.f0 = 2*pi-acos(dot(e2_,newpos(1,1:2))/norm(e2_)/norm(newpos(1,1:2)));
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

