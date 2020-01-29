classdef TimeSystem
    %时间系统类，初始化输入协调世界时（UTC），属性包含常用时间
    %   Detailed explanation goes here
    
    properties
        UTC %协调世界时
        lambdaG % 地理经度
        lambda %极移修正后的经度，由于极移数据不易获取，这里认为等于地理经度
        TAI %国际原子时
        TT %地球时
        TDT %地球动力时
        ET %历书时
        %TDB，质心动力时，不常用
        %TCG，地心坐标时，不常用
        %TCB，质心坐标时，不常用
        UT1 %世界时, UT0和UT2不常用
        Smean %格林尼治平恒星时
        S %格林尼治真恒星时
        smean %当地平恒星时
        s %当地真恒星时
    end
    
    methods
        function obj = TimeSystem(UTC_,lambdaG_)
            %构造函数
            obj.UTC = UTC_;
            obj.lambdaG = lambdaG_; 
            obj.lambda = obj.lambdaG ; %由于极移数据不易获取，这里认为等于地理经度
            obj.TAI = obj.UTC2TAI(obj.UTC);
            obj.TT = obj.TAI2TT(obj.TAI);
            obj.TDT = obj.TT;
            obj.ET = obj.TT;
            obj.UT1 = obj.UTC2U1(obj.UTC);
            obj.Smean = obj.UT12Smean(obj.UT1,obj.TT);
            obj.S = obj.Smean2S(obj.Smean);
            obj.smean = obj.Smean2smean(obj.Smean,obj.lambda);
            obj.s = obj.S2s(obj.S,obj.lambda);
            
        end
        
        function  TAI_ = UTC2TAI(obj,UTC_)
            %计算DAI（闰秒），需要之后用爬虫爬数据，这里先指定一个值
            DAI_ = 1/3600/24; %单位，天
            TAI_ = UTC_ + DAI_;
        end
        
        function TT_ = TAI2TT(obj,TAI_)
            TT_ = TAI_+32.184;
        end
        
        function UT1_ = UTC2U1(obj,UTC_)
            %计算DUT1，需要之后用爬虫爬数据，这里先用一值
            DUT1_ = 0.2/3600/24;
            UT1_ = UTC_ + DUT1_;
        end
        
        function Smean_ = UT12Smean(obj,UT1_,TT_)
            Du = juliandate(UT1_)-2451545; 
            theta = 0.7790572732640+1.00273781191135448*Du; %地球转动角，单位是地球转过的圈数
            T = (juliandate(TT_)-2451545)/36525;
            Smean_=86400*theta+(0.014506+4612.156534*T+1.3915817*T^2-0.00000044*T^3-0.000029956*T^4-0.0000000368*T^5)/15;   
        end
        
        function S_ = Smean2S(obj,Smean_)
            %εr主要由赤经章动引起，还需要引入一些高精度补偿项，这里先忽略
            epsilonr = 0;
            S_ = Smean_+epsilonr/15;
        end
        
        function smean_ = Smean2smean(obj,Smean_,lambda_)
            smean_ = Smean_ + 3600/15*lambda_;
        end
        
        function s_ = S2s(obj,S_,lambda_)
            s_ = S_ + 3600/15*lambda_;
        end
    end  
        
end