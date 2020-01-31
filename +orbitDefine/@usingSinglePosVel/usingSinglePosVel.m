classdef usingSinglePosVel
    %根据初始位置和初始速度，确定轨道要素
    properties
        a %半长轴
        e_ %偏心率矢量
        e %偏心率
        Omega %升交点经度
        omega %近心点角距
        i %轨道倾角
        tao %过近心点时刻
        f0 %初始真近点角
        E0 %初始偏近点角
        M0 %初始平近点角
        h %动量矩
        p %半通经
    end
    
    methods
        function obj = usingSinglePosVel(r0,v0,UTC)
            %构造函数
            import constants.AstroConstants
            obj.h=cross(r0,v0);
            obj.e_=cross(v0,obj.h)/AstroConstants.GM-r0/norm(r0);
            h_scal=norm(obj.h);
            obj.e=norm(obj.e_);
            obj.p=h_scal^2/AstroConstants.GM;
            obj.a=obj.p/(1-norm(obj.e_)^2);
            obj.i=acosd(obj.h(3)/h_scal);
            obj.Omega=atan2(obj.h(1),-obj.h(2));
            if obj.Omega<0
                obj.Omega=(obj.Omega+2*pi)*180/pi;
            else
                obj.Omega=(obj.Omega)*180/pi;
            end
            obj.omega=atan2(obj.e_(3),((obj.e_(2)*sin(obj.Omega/180*pi)+obj.e_(1)*cos(obj.Omega/180*pi))*sin(obj.i/180*pi)));
            if obj.omega<0
                obj.omega=(obj.omega+2*pi)*180/pi;
            else
                obj.omega=(obj.omega)*180/pi;
            end
            u=atan2(r0(3),((r0(2)*sin(obj.Omega/180*pi)+r0(1)*cos(obj.Omega/180*pi))*sin(obj.i/180*pi)));
            if u<0
                u=(u+2*pi)*180/pi;
            else
                u=(u)*180/pi;
            end
            obj.f0=u-obj.omega;
            obj.E0 = 2*atan(tan(obj.f0/2)*sqrt((1-obj.e)/(1+obj.e)));
            if(abs(obj.E0-obj.f0)>pi/2)
                if(abs(obj.E0+pi-obj.f0)>pi/2)
                    obj.E0 = obj.E0 + 2*pi;
                else
                    obj.E0 = obj.E0 + pi;
                end
            end
            obj.M0 = obj.E0-obj.e*sin(obj.E0);
            obj.tao = UTC-obj.M0*sqrt(obj.a^3/AstroConstants.GM)/3600/24;
        end
    end
end