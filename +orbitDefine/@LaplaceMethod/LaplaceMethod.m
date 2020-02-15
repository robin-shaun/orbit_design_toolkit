classdef LaplaceMethod
    %使用改进的拉普拉斯方法确定轨道
    
    properties
        r0 %航天器在地心惯性系下的初始位置
        v0 %航天器在地心惯性系下的初始速度
        a %半长轴
        e %偏心率
        omega %近心点角距
        Omega %升交点经度
        i %轨道倾角
        tao %过近心点时刻
        f0 %初始真近点角
        E0 %初始偏近点角
        M0 %初始平近点角
    end
    
    methods
        function obj = LaplaceMethod(stationpos,spacecraftdir,s,UTC)
            %构造函数
            %输入为测站位置、航天器方向和当地真恒星时
            import constants.AstroConstants
            error = 1000;
            len = length(stationpos);
            %初始化拉格朗日系数
            F = ones(len,1);
            for i = 1:len
                G(i) = s(i)-s(1);
            end
            tmp = cross(spacecraftdir,stationpos);
            for i = 1:len
                b(3*i-2)=-tmp(i,3);
                b(3*i-1)=-tmp(i,1);
                b(3*i)=-tmp(i,2);
            end
            b = b';
            lambda = spacecraftdir(:,1);
            yita = spacecraftdir(:,2);
            niu = spacecraftdir(:,3);
            solution_ = zeros(6,1);
         while(error>1e-6) 
                for i = 1:len
                    A(3*i-2,:) = [F(i)*yita(i),-F(i)*lambda(i),0,G(i)*yita(i),-G(i)*lambda(i),0];
                    A(3*i-1,:) = [0,F(i)*niu(i),-F(i)*yita(i),0,G(i)*niu(i),-G(i)*yita(i)];
                    A(3*i,:) = [-F(i)*niu(i),0,F(i)*lambda(i),-G(i)*niu(i),0,G(i)*lambda(i)];  
                end
                solution = lsqminnorm(A,b,'warn');
                error = norm(solution-solution_);
                solution_ = solution;
                r0 = solution(1:3);
                v0 = solution(4:6);
                tmp = orbitDefine.usingSinglePosVel(r0,v0,UTC);
                for i = 1:len
%                     E0 = tmp.E0/180*pi;
%                     fun = @(E)(sqrt(AstroConstants.GM/tmp.a^3)*(s(i)-s(1))-(E-E0)+tmp.e*(sin(E)-sin(E0)));
%                     options = optimoptions('fsolve','Display','none');
%                     E = fsolve(fun,0,options); %求解开普勒方程
%                     E-E0 
                    sigma0 = dot(r0,v0)/sqrt(AstroConstants.GM); 
                    dM=sqrt(AstroConstants.GM/tmp.a^3)*(s(i)-s(1));
                    dE=dM;%dE的初值
                    dme=1;
                    while abs(dme)>1e-7
                        dme=dE+sigma0/sqrt(tmp.a)*(1-cos(dE))-(1-norm(r0)/tmp.a)*sin(dE)-dM;%P93页公式，dme为dE和dM的差值
                        ddme=1+sigma0/sqrt(tmp.a)*sin(dE)-(1-norm(r0)/tmp.a)*cos(dE);%差值的倒数
                        dE=dE-dme/ddme;%P118,牛顿迭代法
                    end
                    F(i) = 1 - tmp.a/norm(r0)*(1-cos(dE));
                    G(i) = tmp.a*sigma0/sqrt(AstroConstants.GM)*(1-cos(dE))+norm(r0)*sqrt(tmp.a/AstroConstants.GM)*sin(dE);
                end
                    
         end
         obj.r0 = r0;
         obj.v0 = v0;
         obj.a = tmp.a;
         obj.e = tmp.e;
         obj.i = tmp.i;
         obj.Omega = tmp.Omega;
         obj.omega = tmp.omega;
         obj.f0 = tmp.f0;
         obj.tao = tmp.tao;
         obj.E0 = tmp.E0;
         obj.M0 = tmp.M0;
        end
        
    end
end

