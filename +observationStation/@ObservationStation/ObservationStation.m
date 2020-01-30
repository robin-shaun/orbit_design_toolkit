
classdef ObservationStation
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Glatitude %地理纬度，rad
        s %当地真恒星时，秒
        altitude %当地海拔，m
        azimuth %方位角，rad
        elevation %仰角（高低角），rad
        distance %航天器与测站的距离，m
        Dazimuth %方位角变化率，rad/s
        Delevation %仰角变化率，rad/s
        Ddistance %航天器与测站的距离变化率，m/s
        stationPos %地心惯性系下测站位置，m
        C %测站坐标系到地心惯性系的方向余弦阵
        spacecraftPos %地心惯性系下航天器位置，m
        spacecraftVel %地心惯性系下航天器速度，m/s
    end
    
    methods
        function obj = ObservationStation(B,s,H,A,E,D,Adot, Edot,Ddot)
            %构造函数
            %把角度都转为弧度
            obj.Glatitude = B/180*pi;
            obj.s = s/180*pi; 
            obj.altitude = H;
            obj.azimuth = A/180*pi; 
            obj.elevation = E/180*pi; 
            obj.distance = D;
            obj.Dazimuth = Adot;
            obj.Delevation = Edot;
            obj.Ddistance = Ddot;
            obj.stationPos = obj.stationpos();
            obj.C = obj.station2inertial(obj.s,obj.Glatitude);
            obj.spacecraftPos = obj.spacecraftpos();
            obj.spacecraftVel = obj.spacecraftvel();            
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
        
        function spacecraftpos = spacecraftpos(obj) 
            rou = obj.distance*[cos(obj.elevation)*sin(obj.azimuth),cos(obj.elevation)*cos(obj.azimuth),sin(obj.elevation)]';
            spacecraftpos = obj.stationPos + obj.C*rou;
        end

        function spacecraftvel = spacecraftvel(obj)
            import constants.AstroConstants
            spacecraftvel = obj.C*[obj.Ddistance*cos(obj.elevation)*sin(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*sin(obj.azimuth)+obj.distance*obj.Dazimuth*cos(obj.elevation)*cos(obj.azimuth),obj.Ddistance*cos(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Dazimuth*cos(obj.elevation)*sin(obj.azimuth),obj.Ddistance*sin(obj.elevation)+obj.distance*obj.Delevation*cos(obj.elevation)]'+cross([0,0,AstroConstants.we]',obj.spacecraftPos);
        end
    end
end

