
classdef ObservationStation
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Glatitude %地理纬度，标量，rad
        s %当地真恒星时，数组，秒
        altitude %当地海拔，标量，m
        azimuth %方位角，数组，rad
        elevation %仰角（高低角），数组，rad
        distance %航天器与测站的距离，数组，m
        Dazimuth %方位角变化率，数组，rad/s
        Delevation %仰角变化率，数组，rad/s
        Ddistance %航天器与测站的距离变化率，数组，m/s
        stationPos %测站位置（在地心惯性系下），数组，m
        spacecraftPos %航天器位置（在地心惯性系下），数组，m
        spacecraftVel %航天器速度（在地心惯性系下），数组，m/s
    end
    
    methods
        function obj = ObservationStation(B,s,H,A,E,D,Adot, Edot,Ddot)
            %构造函数
            %把角度都转为弧度
            %这样的处理是为了解决输入和输出的维数的合理性
            for i=1:length(A)
                obj.Glatitude = B/180*pi;
                obj.s = s(i)/180*pi; 
                obj.altitude = H;
                obj.azimuth = A(i)/180*pi; 
                obj.elevation = E(i)/180*pi; 
                obj.distance = D(i);
                obj.Dazimuth = Adot(i);
                obj.Delevation = Edot(i);
                obj.Ddistance = Ddot(i);
                obj.stationPos(:,i) = obj.stationpos();
                C = obj.station2inertial(obj.s,obj.Glatitude);
                obj.spacecraftPos(:,i) = obj.spacecraftpos(C,i);
                obj.spacecraftVel(:,i) = obj.spacecraftvel(C,i);   
            end         
            obj.s = s/180*pi; 
            obj.azimuth = A/180*pi; 
            obj.elevation = E/180*pi; 
            obj.distance = D;
            obj.Dazimuth = Adot;
            obj.Delevation = Edot;
            obj.Ddistance = Ddot;
            obj.stationPos = obj.stationPos';
            obj.spacecraftPos = obj.spacecraftPos';
            obj.spacecraftVel = obj.spacecraftVel';
        end
        
        function stationpos = stationpos(obj)
            import constants.AstroConstants
            xe = (AstroConstants.ae/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*cos(obj.Glatitude);
            ze = (AstroConstants.ae*(1-AstroConstants.ee^2)/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*sin(obj.Glatitude);
            stationpos = [xe*cos(obj.s),xe*sin(obj.s),ze]';
        end

        function C = station2inertial(obj,s_,B_)
            % 测站地平坐标系到地心惯性坐标系的转换,输入单位为rad
            C=[-sin(s_),-cos(s_)*sin(B_),cos(s_)*cos(B_);cos(s_),-sin(s_)*sin(B_),sin(s_)*cos(B_);0,cos(B_),sin(B_)];
        end
        
        function spacecraftpos = spacecraftpos(obj,C,i) 
            rou = obj.distance*[cos(obj.elevation)*sin(obj.azimuth),cos(obj.elevation)*cos(obj.azimuth),sin(obj.elevation)]';
            spacecraftpos = obj.stationPos(:,i) + C*rou;
        end

        function spacecraftvel = spacecraftvel(obj,C,i)
            import constants.AstroConstants
            spacecraftvel = C*[obj.Ddistance*cos(obj.elevation)*sin(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*sin(obj.azimuth)+obj.distance*obj.Dazimuth*cos(obj.elevation)*cos(obj.azimuth),obj.Ddistance*cos(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Dazimuth*cos(obj.elevation)*sin(obj.azimuth),obj.Ddistance*sin(obj.elevation)+obj.distance*obj.Delevation*cos(obj.elevation)]'+cross([0,0,AstroConstants.we]',obj.spacecraftPos(:,i));
        end
    end
end

